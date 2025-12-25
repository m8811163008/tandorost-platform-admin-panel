
# Introduction
Metrics panel for tandorost platform

# Git Trunk Strategy

This document outlines the Git trunk strategy used in the fitness platform project. The strategy focuses on maintaining a clean and efficient workflow for development, ensuring that the main branch remains stable while allowing for feature development and collaboration.

## Branching Conventions

1. **Main Branch**: The `main` branch is the primary branch where the source code of HEAD always reflects a production-ready state. All code in this branch should be thoroughly tested and reviewed.

2. **Feature Branches**: New features should be developed in separate branches created from the `main` branch. The naming convention for feature branches is as follows:
   - `feature/<feature-name>`
   - Example: `feature/user-authentication`

3. **Sub-Feature Branches**: For smaller enhancements or modifications to existing features or usecases, create sub-feature branches from the corresponding feature branch. The naming convention is:
   - `feature/<feature-name>/<sub-feature-name>`
   - Example: `feature/user-authentication/reset-password`

4. **Bugfix Branches**: Bug fixes should also be developed in separate branches, named as follows:
   - `bugfix/<bug-description>`
   - Example: `bugfix/fix-login-error`

## Merging Practices

1. **Pull Requests**: All changes must be submitted via pull requests (PRs) to the `main` branch. Each PR should be reviewed by at least one other team member before merging.

2. **Squash Merging**: When merging feature or bugfix branches, use the squash merge strategy to keep the commit history clean. This combines all commits from the feature branch into a single commit on the `main` branch.

3. **Rebasing**: Before creating a pull request, ensure that your feature branch is up to date with the `main` branch by rebasing. This helps to avoid merge conflicts and keeps the history linear.

## Release Management

1. **Versioning**: Follow semantic versioning (MAJOR.MINOR.PATCH) for releases. Increment the version number based on the nature of the changes:
   - MAJOR: incompatible API changes
   - MINOR: added functionality in a backward-compatible manner
   - PATCH: backward-compatible bug fixes

2. **Release Branches**: For preparing a new release, create a release branch from the `main` branch:
   - `release/vX.Y.Z`
   - Example: `release/v1.0.0`
   - Git : `git branch release/vX.Y.Z`

3. **Tagging Releases**: After merging a release branch into `main`, tag the commit with the version number:
   - `git tag -a vX.Y.Z -m "Release version X.Y.Z"`
Then Push the tag into origin:
    # Push a specific tag
    - `git push origin vX.Y.Z"` 
    # OR, push all local tags at once (common practice after a release)
    - `git push --tags"` 


Tagging a Commit
"Tag the commit with the version number" means applying a permanent, human-readable alias or label directly to a specific point in your Git history, which corresponds to the final state of the code for that release.It provides a clear, memorable reference point. Instead of telling someone to use "commit a1b2c3d4f5g6...," you can simply tell them to use v1.0.0 and improve immutability and stability.

The trunk branch is main (see the "Main Branch" section in readme.md). Short recommended flow:
Do not add comit directlly on truch branch if you can and use branch and merge back into truck.
Use feature branches for development (e.g. feature/...) and open PRs into main.

Create a release branch from main for stabilizing a release: release/vX.Y.Z. Run CI/CD and deploy that release branch to staging/testing (e.g., your Python backend, cafe bazzar, Google play, web server).
Our main branch is named truck to use A domain-specific language (DSL) and A domain-specific language model (DSLM). 
After verification, merge the release branch back into main and create a tag on main (vX.Y.Z) for the production release. Deploy production from the tagged commit on main and deploy on stores and web etc.// TODO how to create favors 
Keep main always production-ready; use release branches for pre-release testing and fixes.

By following this Git trunk strategy, we ensure a streamlined development process that promotes collaboration, code quality, and efficient release management.

## add to ubunto commands
flutter build web --release  --base-href "/admin/"

copy files
scp -r build/web/* root@91.228.186.219:/var/www/tandorost-a.ir/admin 
