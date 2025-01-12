# Submodules Commands

## Update submodules

```git submodule update --init```
or

```git submodule update --init --recursive```

## Sync submodules after changing modules list in .gitmodules

```git submodule sync```

## Commit your changes

```git add .gitmodules```
```git commit -m "Updated submodules configuration```

## If you cloned your repo and submodules are missing you might have missed the
--recursive flag

```git clone --recursive <repository-url>```

# Remove Submodules

## Remove the submodule enry from .git/config
```git submodule deinit -f path/to/submodule```

## Remove the submodule dir from the host project .git/modules dir
```rm -rf .git/modules/path/to/submodule```

## Remove the entry in .gitmodules and remove the submodule dir located at path/to/submodule
```git rm -rf path/to/submodule```

#Troubleshooting
## Force Update:
Sometimes, a force update can help if there's a discrepancy in commit hashes or if there are local changes

```git submodule update --init --recursive --force sources_non_forked/```

## Delete and Reinitialize:
For any specific empty folder:
Remove the local submodule:
```git submodule deinit -f sources_non_forked/<submodule_name>
git rm -f sources_non_forked/<submodule_name>```

Remove any remaining metadata:
```rm -rf .git/modules/sources_non_forked/<submodule_name>```
Re-add the submodule if necessary:
```git submodule add <url> sources_non_forked/<submodule_name>```
