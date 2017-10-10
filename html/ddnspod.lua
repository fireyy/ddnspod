module("luci.controller.api.ddnspod", package.seeall)
function index()
    local page   = node("api","misstar")
    page.target  = firstchild()
    page.title   = ("")
    page.order   = 100
    page.sysauth = "admin"
    page.sysauth_authenticator = "jsonauth"
    page.index = true
    
    
	entry({"api", "misstar", "get_ddnspod"}, call("get_ddnspod"), (""), 635)
    entry({"api", "misstar", "set_ddnspod"}, call("set_ddnspod"), (""), 636)

end

local LuciHttp = require("luci.http")
local XQConfigs = require("xiaoqiang.common.XQConfigs")
local XQSysUtil = require("xiaoqiang.util.XQSysUtil")
local XQErrorUtil = require("xiaoqiang.util.XQErrorUtil")
local uci = require("luci.model.uci").cursor()
local LuciUtil = require("luci.util")


function set_ddnspod()
    local code = 0
    local result = {}
    local set=false
    local ddnspod_enable_switch=LuciHttp.formvalue("ddnspod_enable")
    local ddnspod_dns=LuciHttp.formvalue("ddnspod_dns")
    local ddnspod_cycle=LuciHttp.formvalue("ddnspod_cycle")
    local ddnspod_domain=LuciHttp.formvalue("ddnspod_domain")
    local ddnspod_name=LuciHttp.formvalue("ddnspod_name")
    local ddnspod_token=LuciHttp.formvalue("ddnspod_token")
    local ddnspod_last_act=LuciHttp.formvalue("ddnspod_last_act")
    
    
	LuciUtil.exec("uci set misstar.ddnspod.enable=" ..ddnspod_enable_switch)
	LuciUtil.exec("uci set misstar.ddnspod.ddnspod_dns=" ..ddnspod_dns)
	LuciUtil.exec("uci set misstar.ddnspod.ddnspod_cycle=" ..ddnspod_cycle)
	LuciUtil.exec("uci set misstar.ddnspod.ddnspod_domain=" ..ddnspod_domain)
	LuciUtil.exec("uci set misstar.ddnspod.ddnspod_name=" ..ddnspod_name)
	LuciUtil.exec("uci set misstar.ddnspod.ddnspod_token=" ..ddnspod_token)
	
	LuciUtil.exec("uci commit misstar")
	
	LuciUtil.exec("/etc/misstar/applications/ddnspod/script/ddnspod stop")
	LuciUtil.exec("/etc/misstar/applications/ddnspod/script/ddnspod start")
	
    result["code"] = 0
    if result.code ~= 0 then
        result["msg"] = LuciHttp.formvalue("ddnspod_enable_switch")
    end
    LuciHttp.write_json(result)
end


function get_ddnspod()
	local result = {}
	local ddnspod_enable
	result.ddnspod_enable = uci:get("misstar","ddnspod","enable")
	result.ddnspod_dns = uci:get("misstar","ddnspod","ddnspod_dns")
	result.ddnspod_cycle = uci:get("misstar","ddnspod","ddnspod_cycle")
	result.ddnspod_domain = uci:get("misstar","ddnspod","ddnspod_domain")
	result.ddnspod_name = uci:get("misstar","ddnspod","ddnspod_name")
	result.ddnspod_token = uci:get("misstar","ddnspod","ddnspod_token")
	result.ddnspod_last_act = uci:get("misstar","ddnspod","ddnspod_last_act")
	result.version = uci:get("misstar","ddnspod","version")
	result.ddnspod_status=LuciUtil.exec("/etc/misstar/applications/ddnspod/script/ddnspod status")
	result["code"]=0
	LuciHttp.write_json(result)
end
