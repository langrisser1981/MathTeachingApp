# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MathTeachingApp is an iOS educational app for Grade 3 students to practice subtraction with 4-digit numbers (1000-9999). The app presents problems with 2-3 randomly placed blanks that students fill in, then validates their answers with visual feedback.

## Build and Development Commands

### Building and Running
```bash
# Open the project in Xcode
open MathTeachingApp.xcodeproj

# Build the project
xcodebuild -scheme MathTeachingApp -configuration Debug build

# Run tests
xcodebuild -scheme MathTeachingApp -destination 'platform=iOS Simulator,name=iPhone 15' test

# Run specific test target
xcodebuild -scheme MathTeachingApp -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:MathTeachingAppTests test
```

### Requirements
- Xcode 14.0+
- macOS 12.0+
- iOS 15.0+ deployment target

## Architecture

### MVVM Pattern
The app follows the Model-View-ViewModel architecture:

- **Models** (`Models/Models.swift`): All data models are in a single file
  - `MathProblem`: Represents a subtraction problem with blanks
  - `BlankPosition`: Tracks which digit positions are blanks (row + digitIndex)
  - `UserAnswer`: Stores user input for each blank (keyed by blank UUID)
  - `QuizResult`: Contains validation results and statistics per problem
  - `QuizSettings`: Configuration for quiz generation (count, range, difficulty)

- **ViewModel** (`ViewModels/MathQuizViewModel.swift`): Single view model manages entire quiz lifecycle
  - Problem generation with random blanks (2-3 per problem)
  - Answer validation and result tracking
  - Navigation between problems
  - Quiz state management (progress, completion, results)

- **Views** (`Views/`): SwiftUI views organized by responsibility
  - `SettingsView`: Entry point - configures quiz parameters
  - `QuizView`: Main quiz interface with progress bar
  - `SubtractionProblemView`: Displays the subtraction layout
  - `BlankInputView`: Individual blank input field with validation styling
  - `ResultsView`: Shows quiz results and allows review

### State Flow
1. User configures settings in `SettingsView`
2. `MathQuizViewModel.startQuiz()` generates problems and initializes answers
3. `QuizView` presents problems one at a time
4. User fills blanks → validates → moves to next problem
5. After all problems, `ResultsView` displays statistics and allows review

### Key Design Decisions

**Blank Generation**: Blanks are randomly selected from all digit positions across three rows (minuend, subtrahend, difference). The position is tracked as `(row, digitIndex)` where row 0 = minuend, 1 = subtrahend, 2 = answer.

**Answer Storage**: User answers are stored in a nested dictionary structure: `[ProblemID: UserAnswer]` where `UserAnswer` contains `[BlankID: Int]`. This allows partial answers and validation per blank.

**View Model Sharing**: The same `MathQuizViewModel` instance is passed through the view hierarchy (SettingsView → QuizView → ResultsView) using `@StateObject` and `@ObservedObject`.

**Validation Flow**: Validation is manual (button press) not automatic. The `showValidation` flag controls when to display color-coded feedback. Results are saved before advancing to the next problem.

## Development Notes

### Adding New Problem Types
To add addition or other operations:
1. Extend `MathProblem` with operation type enum
2. Update blank generation logic in `generateBlanks()`
3. Modify `SubtractionProblemView` to handle different layouts

### Difficulty Implementation
Current difficulty only affects blank count (easy=2, medium=3, hard=4) via `QuizSettings.Difficulty.blankCount`. Future implementations could factor in borrow/carry complexity.

### Testing Strategy
- `MathTeachingAppTests`: Unit tests for models and view model logic
- `MathTeachingAppUITests`: UI automation tests for quiz flow

### File Organization
- **App entry point**: `App/MathTeachingApp.swift` (launches `SettingsView`)
- **Single model file**: All data structures in `Models/Models.swift`
- **Single view model**: All business logic in `ViewModels/MathQuizViewModel.swift`
- **View components**: Separated by responsibility in `Views/`

## Language and Localization

The app is currently in Traditional Chinese (繁體中文). All UI strings are hardcoded. For localization support, strings should be extracted to `Localizable.strings`.

## Git Commit Message Guidelines

This project follows the AngularJS commit message convention to maintain clear and consistent commit history.

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Header: `<type>(<scope>): <subject>`

**Type** (required) - Must be one of:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code formatting (whitespace, semicolons, etc.) - no functional changes
- `refactor`: Code restructuring without behavior changes
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Build process, tooling, or dependency updates
- `revert`: Reverting a previous commit

**Scope** (optional) - Component or area affected:
- Examples: `quiz`, `settings`, `validation`, `models`, `viewmodel`, `ui`

**Subject** (required):
- Maximum 50 characters
- Imperative mood ("add" not "added" or "adds")
- No period at the end
- Lowercase first letter

### Body (optional)

- Wrap at 72 characters per line
- Explain **why** the change was made, not just what changed
- Describe the problem being solved and the rationale behind the solution
- Use imperative mood

### Footer (optional)

- Reference issue/task numbers: `Closes #123` or `Refs #456`
- Note breaking changes: `BREAKING CHANGE: description of breaking change`

### Examples

```
feat(quiz): add multiplication problem type

Support multiplication problems alongside subtraction.
Extends MathProblem model with operation enum and updates
blank generation to handle different operation layouts.

Closes #12
```

```
fix(validation): correct answer checking for leading zeros

Previously, answers with leading zeros were incorrectly marked
as wrong. Now properly strips leading zeros before validation.

Fixes #45
```

```
refactor(viewmodel): simplify answer validation logic

Extract validation into separate method to improve readability
and make unit testing easier. No behavioral changes.
```

```
docs: update CLAUDE.md with commit guidelines

Add comprehensive commit message format based on AngularJS
convention to maintain consistent commit history.
```

### Key Principles

- **One commit = one logical change**: Keep commits focused and atomic
- **Explain why, not just what**: The diff shows what changed; the message explains why
- **Reference issues**: Link commits to issue tracker for better project management
- **Write for future maintainers**: Assume the reader doesn't have context about the change
- **No AI attribution**: Do not include any references to AI tools, Claude, or code generation tools in commit messages
