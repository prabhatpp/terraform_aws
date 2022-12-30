# aws_daily cost script

if you  want to fetch the daily cost of report in any account id  this script will give the result.
firstly update your credential (access key id , secrete key)
and update the EMAIL FRPM or EMAIL to 
and run the script at any time when you want the report.






import boto3
import variable
import datetime

client = boto3.client(
    'ses',
    region_name='us-east-1',
    aws_access_key_id = variable.aws_access_key_id, 
    aws_secret_access_key = variable.aws_secret_access_key,
)
EMAIL_FROM = variable.EMAIL_FROM
EMAIL_TO = variable.EMAIL_TO  
def build_report(response):
    report="<h2>Time Period : " +str(response["ResultsByTime"][0]["TimePeriod"]) +"</h2>"
    report += "<table border='1px'><tr><th> Resource</th><th>AmortizedCost</th></tr>"
    total=0
    for resource in response["ResultsByTime"][0]["Groups"] :
        amount = resource["Metrics"]["AmortizedCost"]["Amount"]
        report  = report +"<tr><td>"+ resource["Keys"][0] + "</td><td>"+ amount+"</td></tr>"
        total = total+ float(amount)
    report = report + "<tr><td>Total </td><td> " + str(total)+"</td></tr></table>"
    return report
def final_cost_report():
    today = datetime.date.today()
    yesterday = datetime.date.today() - datetime.timedelta(days=1)
    client = boto3.client('ce', region_name='us-east-1',
    aws_access_key_id= variable.aws_access_key_id, 
    aws_secret_access_key=variable.aws_secret_access_key)
    response = client.get_cost_and_usage(
        TimePeriod={
            'Start':datetime.date.strftime(yesterday, '%Y-%m-%d'),
            'End':datetime.date.strftime(today, '%Y-%m-%d')
        },
        GroupBy=[{
            'Type': 'DIMENSION',
            'Key': 'SERVICE'
        }],
        Granularity='DAILY',
        Metrics=[
            'AmortizedCost',
        ],
    )
    # print(response)
    # print( json.dumps(response,indent=4) )
    #print(build_report(response))
    return build_report(response)
    
    # return response
# details = amount()
# ["ResultsByTime"][0]["Total"]["AmortizedCost"]
response = client.send_email(
    Source = EMAIL_FROM,
    Destination={
        'ToAddresses': [EMAIL_TO],
    },
    Message={
        'Subject': {
            'Data': 'AWS Daily Cost details :' + str(datetime.date.today())
        },
        'Body': {
            'Html': {
                'Data': '<h1>AWS Daily Cost:</h1> '+ final_cost_report(),
            },
        }
    },
)

print(response)
 
