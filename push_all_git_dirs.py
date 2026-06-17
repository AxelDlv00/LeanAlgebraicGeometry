#!/usr/bin/env python3
import os
import argparse
import subprocess
from pathlib import Path

WORKSPACE_ROOT = Path(__file__).parent.resolve()

def get_all_projects():
    projects = []
    
    # 1. Main projects
    main_dir = WORKSPACE_ROOT / "MainProjects"
    if main_dir.exists():
        for d in main_dir.iterdir():
            if d.is_dir() and d.name != "README.md":
                projects.append(d)
                
    # 2. Sub projects
    sub_dir = WORKSPACE_ROOT / "SubProjects"
    if sub_dir.exists():
        for d in sub_dir.iterdir():
            if d.is_dir() and d.name not in ["RelatedPapersFormalisation", "README.md"]:
                projects.append(d)
                
        # 3. Paper subprojects
        papers_dir = sub_dir / "RelatedPapersFormalisation"
        if papers_dir.exists():
            for d in papers_dir.iterdir():
                if d.is_dir() and d.name != "README.md":
                    projects.append(d)
                    
    return sorted(projects)

def run_git(git_dir, work_tree, args):
    env = os.environ.copy()
    env["GIT_DIR"] = str(git_dir)
    env["GIT_WORK_TREE"] = str(work_tree)
    # Run git command
    res = subprocess.run(
        ["git"] + args,
        cwd=str(work_tree),
        env=env,
        capture_output=True,
        text=True
    )
    return res

def main():
    parser = argparse.ArgumentParser(description="Push all inner git-dirs to their remotes.")
    parser.add_argument(
        "--base-url",
        help="Base URL of git remotes (e.g. 'https://github.com/AxelDlv00'). If specified, "
             "projects without configured remotes will have 'origin' added as '{base-url}/{project-name}-git-dir.git'."
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Force push changes (git push -f)"
    )
    args = parser.parse_args()
    
    projects = get_all_projects()
    print(f"Found {len(projects)} projects.")
    
    for p in projects:
        rel = p.relative_to(WORKSPACE_ROOT)
        git_dir = p / ".archon" / "git-dir"
        
        if not git_dir.is_dir():
            print(f"[{rel}] Skipped (no .archon/git-dir found)")
            continue
            
        # Get configured remotes
        res = run_git(git_dir, p, ["remote"])
        remotes = [line.strip() for line in res.stdout.splitlines() if line.strip()]
        
        if not remotes:
            if args.base_url:
                # Add origin remote based on project name
                proj_name = p.name.lower().replace(" ", "-")
                remote_url = f"{args.base_url.rstrip('/')}/{proj_name}-git-dir.git"
                print(f"[{rel}] Adding remote 'origin' pointing to: {remote_url}")
                add_res = run_git(git_dir, p, ["remote", "add", "origin", remote_url])
                if add_res.returncode != 0:
                    print(f"[{rel}] Failed to add remote: {add_res.stderr.strip()}")
                    continue
                remotes = ["origin"]
            else:
                print(f"[{rel}] Warning: No remote configured. Use --base-url to auto-configure one.")
                continue
                
        # Push to each remote
        # Find current branch
        branch_res = run_git(git_dir, p, ["rev-parse", "--abbrev-ref", "HEAD"])
        current_branch = branch_res.stdout.strip()
        if branch_res.returncode != 0 or not current_branch:
            current_branch = "main" # fallback
            
        for remote in remotes:
            print(f"[{rel}] Pushing branch '{current_branch}' to remote '{remote}'...")
            push_args = ["push", remote, current_branch]
            if args.force:
                push_args.append("-f")
            
            push_res = run_git(git_dir, p, push_args)
            if push_res.returncode == 0:
                print(f"[{rel}] Successfully pushed!")
            else:
                print(f"[{rel}] Push failed:\n{push_res.stderr.strip()}")

if __name__ == "__main__":
    main()
