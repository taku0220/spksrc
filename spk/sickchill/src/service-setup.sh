PYTHON_DIR="/usr/local/python3"
PIP=${SYNOPKG_PKGDEST}/env/bin/pip3
PATH="${SYNOPKG_PKGDEST}/bin:${SYNOPKG_PKGDEST}/env/bin:${PYTHON_DIR}/bin:${PATH}"
HOME="${SYNOPKG_PKGDEST}/var"
VIRTUALENV="${PYTHON_DIR}/bin/virtualenv"
PYTHON="${SYNOPKG_PKGDEST}/env/bin/python3"
SC_INSTALL_DIR="${SYNOPKG_PKGDEST}/share/SickChill"
SC_BINARY="${SC_INSTALL_DIR}/SickChill.py"
SC_DATA_DIR="${SYNOPKG_PKGDEST}/var/data"
SC_CFG_FILE="${SC_DATA_DIR}/config.ini"


GROUP="sc-download"

SERVICE_COMMAND="${PYTHON} ${SC_BINARY} --daemon --nolaunch --pidfile ${PID_FILE} --config ${SC_CFG_FILE} --datadir ${SC_DATA_DIR} --port 8081"

set_config() {
    if [ -f "${SC_CFG_FILE}" ]; then
        if [ -n "${wizard_username}" ] && [ -n "${wizard_password}" ]; then
            sed -i "/^\s*web_username\s*=/s/\s*=\s*.*/ = ${wizard_username}/" ${SC_CFG_FILE}
            sed -i "/^\s*web_password\s*=/s/\s*=\s*.*/ = ${wizard_password}/" ${SC_CFG_FILE}
        fi
        # postupgrade we don't want to change their branch or commit, just remove them as the updater should repopulate these
        sed -i "/^branch/d" ${SC_CFG_FILE}
        sed -i "/^cur_commit_hash/d" ${SC_CFG_FILE}
        sed -i "/^cur_commit_branch/d" ${SC_CFG_FILE}

        # Make sure we always update the port in their restored config
        sed -i "s/\(web_port *= *\).*/\18081/" ${SC_CFG_FILE}
    else
        mkdir -p ${SC_DATA_DIR}
        cat << EOF > ${SC_CFG_FILE}
[General]
web_username = ${wizard_username}
web_password = ${wizard_password}
branch = ${SC_GIT_BRANCH}
web_port = 8081
update_frequency = 24
EOF
    fi
}

service_preinst ()
{
    # Avoid ssl errors in git
    SSL_CRT="/etc/ssl/certs/ca-certificates.crt"
    if [ -f ${SSL_CRT} ]; then
        ${GIT} config --system http.sslCAInfo ${SSL_CRT} > /dev/null 2>&1
    fi
}

service_postinst() {
    # Create a Python virtualenv
    ${VIRTUALENV} --system-site-packages ${SYNOPKG_PKGDEST}/env >>${INST_LOG}

    # Install the wheels
    ${PIP} install --no-deps --no-index -U --force-reinstall -f ${SYNOPKG_PKGDEST}/share/wheelhouse ${SYNOPKG_PKGDEST}/share/wheelhouse/*.whl >> ${INST_LOG} 2>&1

    if [ "${SYNOPKG_PKG_STATUS}" == "INSTALL" ]; then
        set_config
    fi
}

service_postupgrade() {
    # Do we need to do this?
    # chown -R sc-download:sc-download ${SC_DATA_DIR}
    set_config
}
