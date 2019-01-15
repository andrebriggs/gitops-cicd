# Write your commands here
echo "Current directory is:" && pwd
echo "Contents are:" && ls -a

#Download latest linux Fabrikate release. Save as fab.zip (TODO use variable)
curl -Lo fab.zip https://github.com/Microsoft/fabrikate/releases/download/0.1.2/fab-v0.1.2-linux-amd64.zip
unzip fab.zip
echo "Contents after download are:" && ls -la

cd _andrebriggs_fabrikate-acme-company
echo "Current directory is:" && pwd
echo "Contents are:" && ls -a

#Install and generate with Fabrikate
../fab install 
../fab generate prod

echo "Contents after generation are:" && ls -a

cd ..

#Go into the Azure DevOps git repo. Temporary hack is to store "secrets" in this private repo
cd _services-team-bedrock

echo "Current directory is:" && pwd
echo "Contents are:" && ls -a

#Create .ssh directory
echo "mkdir ~/.ssh/"
mkdir ~/.ssh/

#Set the permission on the private key
chmod 400 id_rsa

# TODO: Set up a AZ Service Princpal and pull the private key from an Azure Key Vault. Use Azure CLI to do this
 
#Copy public and private keys to ~/.ssh 
cp id_rsa.pub ~/.ssh/id_rsa.pub
cp id_rsa ~/.ssh/id_rsa

#Copy empty known_hosts file to ~/.ssh 
cp known_hosts ~/.ssh/known_hosts

#Add GitHub.com to known_hosts file
ssh-keyscan -H github.com >> ~/.ssh/known_hosts

#Add the copied keys by using ssh-add. We need to start the ssh-agent first
ls ~/.ssh/
eval `ssh-agent -s`
ssh-add

#Use ssh to checkout the destination repo (TODO use variable)
cd ..
git clone git@github.com:andrebriggs/acme-company-yaml.git yaml

ls -a
cd yaml

echo "Current directory is:" && pwd
echo "Contents are:" && ls -a

#Copy over the generated files and add them all (TODO use variable)
cp -r ../_andrebriggs_fabrikate-acme-company/generated/* ./
git add --all

#Set git identity for commit
git config user.email "me@azuredevops.com"
git config user.name "Automated Account"

#Commit and push to master
git commit -m "Automated commit"
echo "Pushing file"
git push 