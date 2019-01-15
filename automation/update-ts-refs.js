const getDeps = require(__dirname + '/get-ts-deps.js');
const path = require('path');

async function main() {
    const originFolder = path.resolve(process.argv[2]); // assumes it's going to be an absolute path.

    const { npmDependencies, tsReferences } = await getDeps.getDependencies(originFolder, path.resolve(originFolder, 'package.json'));
    
    const dedupedNpmDependencies = getDeps.dedupeDependencies(npmDependencies);

    const toInstall = [];

    for(const packageName in dedupedNpmDependencies)
        for(const version of dedupedNpmDependencies[packageName])
            toInstall.push(packageName + '@' + version);

    const npmInstallationCommands = [
        `npm i ${originFolder} -g ${toInstall.join(' ')}`
    ]

    console.log(JSON.stringify({
        npmInstallationCommands,
        npmDependencies,
        tsReferences
    }, null, '   '));
}

main();