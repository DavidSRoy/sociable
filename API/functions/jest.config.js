
// this config includes typescript specific settings
// and if you're not using typescript, you should remove `transform` property
//testRegex: './(/__tests__/.*|(\\.|/)(test|spec))\\.(jsx?|tsx?)$',
module.exports = {
	testRegex: 'tests(.*|(\\.|/)(test|spec))\\.(js?|jsx?)$',
	testPathIgnorePatterns: ['lib/', 'node_modules/'],
	moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json', 'node'],
	testEnvironment: 'node',
	rootDir: 'tests',
}