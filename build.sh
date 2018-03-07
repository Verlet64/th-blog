set -e x

echo "Building Blog Files"
cd th-blog/
hugo -d $(pwd)/_site
cd - 

echo "tarring files"
cp -rf th-blog/_site/ _site
tar -zcvf ./blog.tar.gz _site


