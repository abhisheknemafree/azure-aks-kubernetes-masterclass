import requests
from datetime import datetime
from fake_useragent import UserAgent
user_agent = UserAgent()
headers = {'User-Agent': user_agent.random}
base_url = "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict"
st_id,dist_id,dt=21,363,datetime.today().strftime('%d-%m-%Y')
send_email=0
#dts=[dt.strftime('%d-%m-%Y') for dt in [datetime.datetime.today()+datetime.timedelta(days=num) for num in range(0,7)]]
otpt={}
for alimit in [45,18]:
    fnl_url=base_url+"?district_id={}&date={}".format(dist_id,dt)
    out=requests.get(fnl_url,headers=headers)
    tmp_loc=""
    for ctr in out.json()['centers']:
        if ctr['block_name']=='Haveli':
            for item in ctr['sessions']:
                if item['available_capacity'] > 0 and item['min_age_limit'] == alimit and item['available_capacity_dose1']>0:
                    t_dt="\nDate: {}\nAvailable slots:{}".format(item['date'],item['available_capacity'])
                    t_doses="\n  Dose 1:{}\n  Dose 2:{}".format(item['available_capacity_dose1'],item['available_capacity_dose2'])
                    t_loc="\nName:    {}\nAddress: {}\nTal:     {}\npincode: {}\n".format(ctr['name'],ctr['address'],ctr['block_name'],ctr['pincode'])
                    tmp_loc=tmp_loc+(t_dt+t_doses+t_loc)
                else:
                    pass
    otpt[alimit]=tmp_loc

fnl_str="\nSlot availability for Dose 1 per age group in Pune:Haveli:\n"
tmp_str=""
for i in otpt.keys():
    #if i == 18:
    t_str1="\nAge group {}+\n-----------------\n".format(i)
    if otpt[i] == "":
        t_str2="None Available\n"
    else:
        t_str2=otpt[i]
    tmp_str=tmp_str+t_str1+t_str2
fnl_str=fnl_str+tmp_str
print(fnl_str)