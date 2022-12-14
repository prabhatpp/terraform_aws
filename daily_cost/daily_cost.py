import boto3
import datetime
client = boto3.client(
    'ses',
    region_name='us-east-1',
    aws_access_key_id='AKIA2CUJN4MFHNP4UE6H',
    aws_secret_access_key='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'
)
EMAIL_FROM = "dwivedi.prabhat@tftus.com"
EMAIL_TO = "dwivedi.prabhat@tftus.com"
def build_csv_report(response):
    report="<h2>Time Period : "+str(response["ResultsByTime"][0]["TimePeriod"]) +"</h2>"
    report += "<table border='1px'><tr><th> Resource</th><th>BlendedCost</th></tr>"
    total=0
    for resource in response["ResultsByTime"][0]["Groups"] :
        amount = resource["Metrics"]["BlendedCost"]["Amount"]
        report = report +"<tr><td>"+ resource["Keys"][0] + "</td><td>"+ amount+"</td></tr>"
        total = total+ float(amount)
    report = report + "<tr><td>Total </td><td> " + str(total)+"</td></tr></table>"
    return report
def amount():
    today = datetime.date.today()
    yesterday = datetime.date.today() - datetime.timedelta(days=1)
    client = boto3.client('ce', region_name='us-east-1',aws_access_key_id='AKIA2CUJN4MFHNP4UE6H',
    aws_secret_access_key='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')
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
            'BlendedCost',
        ],
    )
    # print(response)
    # print( json.dumps(response,indent=4) )
    return build_csv_report(response)
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
            'Data': 'Billing details-NOV-22',
        },
        'Body': {
            'Html': {
                'Data': '<h1>Billing Cost:</h1> '+ amount(),
            },
        }
    },
)
