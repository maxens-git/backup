import os


print("1. Connect to github")
print("2. Upload to github")

choix1 = input(" : ")
if choix1 == "1":
    os.system("sudo docker login ghcr.io -u maxens.verron+github@outlook.com")
elif choix1 == "2":
    tag = input("Tag : ")
    os.system("sudo docker build . -t ghcr.io/maxens-git/backup:" + tag)
    os.system("sudo docker push ghcr.io/maxens-git/backup:" + tag)
else:
    print("Please choose 1 or 2")
