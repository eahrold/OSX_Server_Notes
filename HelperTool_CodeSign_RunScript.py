#!/usr/bin/python

import os
import subprocess
import plistlib

##### begin editing
app_id = "com.eeaapps.blerg"
helper_id ="com.eeaapps.blerg.helper"

helper_info = 'helper/helper-Info.plist'
helper_launchd = 'helper/helper-Launchd.plist'


##### end editing

def getCodeSignIdentity():
    build_dir = os.getenv('BUILT_PRODUCTS_DIR')
    identity = os.getenv('CODE_SIGN_IDENTITY')

    dummy_file = 'csdummypath'
    file = os.path.join(build_dir,dummy_file)
    open(file, 'w').close()
    result_check = subprocess.check_output(['codesign','--force','--sign',identity,file])
    result = subprocess.check_output(['codesign','-d','-r', '-',file])
    
    cid = result.split(dummy_file)[1]
    checkVar(cid)
    return cid

def editAppInfoPlist(cert_id):
    app_info_plist = os.getenv('PRODUCT_SETTINGS_PATH')
    checkVar(app_info_plist)
    
    csstring = "identifier \"%s\"%s" % (helper_id, cert_id)
    
    try:
        p = plistlib.readPlist(app_info_plist)
        p['SMPrivilegedExecutables'] = {helper_id:csstring}
    except:
        p = {'SMPrivilegedExecutables':{helper_id:csstring}}
    
    plistlib.writePlist(p,app_info_plist)


def editHelperInfoPlist(cert_id,project_path):
    helper_info_plist = os.path.join(project_path,helper_info)
    checkVar(helper_info_plist)
    
    csstring = "identifier \"%s\"%s" % (app_id, cert_id)
    
    try:
        p = plistlib.readPlist(helper_info_plist)
        p['SMAuthorizedClients'] = {app_id:csstring}
    except:
        p = {'SMAuthorizedClients':{app_id:csstring}}
    
    plistlib.writePlist(p,helper_info_plist)


def editHelperLaunchD(project_path):
    helper_launchd_plist = os.path.join(project_path,helper_launchd)
    checkVar(helper_launchd_plist)
    try:
        p = plistlib.readPlist(helper_launchd_plist)
        p['Label'] = helper_id
        p['MachServices'] = {helper_id:True}
    except:
        p = {'Label':helper_id,
            'MachServices':{helper_id:True}}
    
    plistlib.writePlist(p,helper_launchd_plist)

def checkVar(var):
    if var == "" or var == None:
        exit(1)

def main():
    ### Configure info from environment
    project_path = os.getenv('PROJECT_DIR')

    ### setup helper paths
    cert_id = getCodeSignIdentity()

    editAppInfoPlist(cert_id)
    editHelperInfoPlist(cert_id,project_path)
    editHelperLaunchD(project_path)

if __name__ == "__main__":
    main()
