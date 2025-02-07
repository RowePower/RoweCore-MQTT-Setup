Step-by-Step Guide for git updates 

1. Open Git Bash or Command Prompt

	Press Win + R, type cmd, and hit Enter to open Command Prompt. Alternatively, you can use Git Bash.

2. Navigate to Your Repository

	Run the following command to move into your repository folder:

	cd C:\Users\matthew.beggs\my-pi-scripts\RoweCore-MQTT-Setup

3. Check Repository Status

	Before making changes, check the current status of your repository:

	git status

	This will show any modified, untracked, or staged files.

4. Add Your Changes

	If you modified specific files, add them using:

	git add setup.sh  # Replace 'setup.sh' with the actual file name

	To add all modified and untracked files at once, use:

	git add .

5. Commit Your Changes

	After staging the changes, commit them with a meaningful message:
	
	git commit -m "Updated Node-RED setup script with hostname prompt and additional modules"

6. Ensure Your Local Branch is Up to Date

	Fetch the latest changes from the remote repository:

	git fetch origin

	Ensure your branch is tracking the correct remote branch:

	git branch --set-upstream-to=origin/main main

7. Push Changes to GitHub

	Now push your committed changes to GitHub:

	git push origin main

8. Verify the Changes on GitHub

	Go to your GitHub repository in your browser and confirm the changes were pushed successfully.

Troubleshooting

	Error: src refspec does not match any

	Ensure you are on the correct branch: git branch

	If your branch is not tracking the remote, run:

	git branch --set-upstream-to=origin/main main

	Error: failed to push some refs

	If your branch is behind the remote branch, first pull the latest changes:

	git pull origin main --rebase

	Then try pushing again.

Conclusion

	Following these steps ensures you can successfully push updates to your GitHub repository from Windows. If you encounter issues, check the error messages and use git status to diagnose problems.