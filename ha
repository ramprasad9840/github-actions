Here’s the exact AWS console click-by-click guide (kept simple and practical):

⸻

🔧 SFTP Gateway HA Upgrade — AWS Console Steps

⸻

1. Take Backup (DO THIS FIRST)

App Backup
	•	Open SFTP Gateway UI
	•	Go to: Settings → Backup & Recovery
	•	Click Export Backup → download YAML file

DB Backup
	•	Go to AWS Console → RDS
	•	Click your database
	•	Click Actions → Take snapshot
	•	Give name → Create

⸻

2. Create Launch Template (from existing setup)
	•	Go to EC2 → Launch Templates
	•	Click Create launch template
	•	Give name (e.g., sftp-new-template)

Now copy details from old instance:

In template:
	•	AMI → Select latest SFTP Gateway AMI (search in Marketplace)
	•	Instance type → same as current
	•	Key pair → same as current
	•	Security group → same as current

⸻

3. Fix Storage (VERY IMPORTANT)
	•	In Launch Template → Storage
	•	Root volume will show 8 GB
	•	Change it to 30 GB or more

⸻

4. Advanced Settings (User Data)
	•	Scroll to Advanced → User data
	•	Copy from your old instance (EC2 → Instance → Actions → View user data)

👉 If upgrading versions:
	•	Check IAM DB auth line
	•	Disable if your old setup used password auth

⸻

5. Save Launch Template
	•	Click Create launch template

⸻

6. Update Auto Scaling Group (ASG)
	•	Go to EC2 → Auto Scaling Groups
	•	Select your SFTP ASG
	•	Click Edit

Change:
	•	Launch Template → select new template
	•	Version → Latest

Click Update

⸻

7. Start New Instances

Option A (recommended)
	•	In ASG → Instance refresh
	•	Click Start instance refresh
	•	Strategy → Rolling update
	•	Min healthy % → 90 (or safe value)

👉 This replaces instances slowly

⸻

8. Verify New Instances
	•	Go to EC2 → Instances
	•	Wait for new instances to come up

Check:
	•	Instance status → running
	•	Target Group → healthy
	•	Login to SFTP → works
	•	Files accessible

⸻

9. Remove Old Instances
	•	ASG will automatically terminate old ones (if using refresh)
	•	Or manually:
	•	Select old instance → Terminate

⸻

🔁 Rollback (if something breaks)
	•	Go to ASG → Edit
	•	Switch back to old Launch Template
	•	Or cancel instance refresh

If DB issue:
	•	Go to RDS → Snapshots → Restore

⸻

🧩 Optional Quick Method (Simpler)

If HA not strict:
	•	Launch new EC2 with latest AMI
	•	Open SFTP UI
	•	Import YAML backup
	•	Point DNS / users to new server

⸻

✅ Done

Your upgrade is complete with minimal/no downtime.

⸻

If you want, tell me:
	•	Are you using NLB or ALB
	•	Any errors (like unhealthy target group, login fail, etc.)

I’ll debug your exact setup quickly 👍