#!/bin/bash

# 确保脚本在项目根目录运行
cd /Users/momo/Documents/工作记录/创新项目/网页部署/测试

# 检查是否有未提交的更改
if [[ -n $(git status --porcelain) ]]; then
    echo "存在未提交的更改，请先提交或暂存这些更改。"
    exit 1
fi

# 创建或切换到 gh-pages 分支
if ! git show-ref --verify --quiet refs/heads/gh-pages; then
    git checkout --orphan gh-pages
    git rm -rf .
    touch .nojekyll
    git add .nojekyll
    git commit -m "Initial commit for gh-pages"
    git checkout -
else
    git worktree add -B gh-pages ./gh-pages origin/gh-pages
fi

# 复制项目文件到 gh-pages 工作树
rsync -av --exclude='deploy.sh' --exclude='gh-pages' ./ ./gh-pages/

# 提交并推送到 GitHub
cd ./gh-pages
git add .
if git diff --staged --quiet; then
    echo "没有更改需要提交。"
else
    git commit -m "Deploy to GitHub Pages"
    git push origin gh-pages
fi

# 清理工作树
cd ..
rm -rf ./gh-pages

echo "部署完成。"