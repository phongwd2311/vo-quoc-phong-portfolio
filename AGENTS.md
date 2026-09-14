# Portfolio repository instructions

## Project purpose

Build and maintain a responsive personal portfolio website using:

- `docs/user-provided-facts.md` as the source of truth for newer facts directly confirmed by the portfolio owner.
- The portfolio PDF as the source of truth for personal facts, education, experience, projects, skills, contact details, and links that are not overridden by newer confirmed information.
- Figma MCP as the source of truth for visual design, layout, typography, colors, spacing, components, responsive behavior, and design assets.
- The existing HTML, CSS, JavaScript, and assets as the implementation to improve rather than replace without reason.

## Repository layout

Expected important paths:

- `index.html`: semantic page markup.
- `styles.css`: responsive presentation.
- `script.js`: interaction only where needed.
- `assets/`: local images, icons, fonts, and exported Figma assets.
- `assets/figma/`: assets exported or downloaded from Figma.
- `docs/source/`: source documents such as the CV PDF.
- `docs/user-provided-facts.md`: newer facts directly confirmed by the portfolio owner.
- `docs/content-inventory.md`: normalized and verified portfolio content generated from all approved sources.
- `docs/figma.md`: Figma file and selected-frame links.
- `docs/project-brief.md`: goals and implementation constraints.
- `docs/decisions.md`: decisions, assumptions, source conflicts, and unresolved questions.
- `docs/qa-report.md`: portfolio verification results when available.
- `.agents/skills/`: repeatable Codex workflows.

## Source-of-truth priority

Use this order when sources conflict:

1. `docs/user-provided-facts.md` controls newer facts directly confirmed by the portfolio owner.
2. The portfolio PDF controls factual information that is not overridden by newer confirmed information.
3. Figma controls visual presentation, layout, typography, colors, spacing, components, responsive behavior, design assets, and intended UI copy.
4. Existing code controls working behavior that is not contradicted by confirmed facts, the PDF, or Figma.
5. Ask the user before inventing, deleting, or materially changing information.

When `docs/user-provided-facts.md` contains newer information than the PDF:

- Use the newer confirmed information.
- Keep the PDF information only when it does not conflict.
- Record the difference in `docs/decisions.md`.
- Mark missing details as `UNVERIFIED`.
- Do not guess responsibilities, technologies, dates, achievements, or employment types.

Never invent:

- employers;
- job titles;
- start or end dates;
- responsibilities;
- technologies;
- achievements;
- project metrics;
- education details;
- contact details;
- social links;
- certifications.

## Required workflow

Before changing code:

1. Inspect the repository and relevant files.
2. Read `AGENTS.md`.
3. Read `docs/project-brief.md`.
4. Read `docs/user-provided-facts.md` when it exists.
5. Locate and read the portfolio PDF under `docs/source/` or the repository root.
6. Read `docs/content-inventory.md` when it exists.
7. Read `docs/figma.md`.
8. Confirm that the required MCP server is available.
9. Review existing `index.html`, `styles.css`, and `script.js`.
10. State a short implementation plan.

For a full portfolio implementation, use these skills in order:

1. `$portfolio-content`
2. Review and approve `docs/content-inventory.md`
3. `$figma-to-portfolio`
4. `$portfolio-qa`
5. `$publish-portfolio` only after explicit user approval

Do not begin visual implementation until the content inventory has been reviewed or the user explicitly asks to continue with unresolved items.

## Content consolidation rules

When creating or updating `docs/content-inventory.md`, combine information from:

1. `docs/user-provided-facts.md`
2. The canonical portfolio PDF
3. Existing website content for comparison only

For every important fact, record:

- the normalized value;
- the source;
- the source page when taken from the PDF;
- whether it is confirmed or `UNVERIFIED`;
- whether it is approved for public display;
- any conflict with another source.

Use one of these source labels:

- `USER_CONFIRMED`
- `PDF`
- `EXISTING_CODE`
- `UNVERIFIED`

Existing website content must not override confirmed facts or the PDF.

## User-provided facts rules

Treat `docs/user-provided-facts.md` as a maintained source document.

- Do not silently rewrite or delete its facts.
- Do not replace confirmed values with older PDF values.
- Do not convert `UNVERIFIED` values into confirmed values without evidence.
- When the user provides a new correction, update this file before updating the website.
- Record meaningful source conflicts in `docs/decisions.md`.
- Ask the user when two directly confirmed facts conflict with each other.
- Keep wording factual and avoid exaggerated claims.
- Do not add responsibilities, achievements, or technologies unless they are directly confirmed.

## Figma rules

- Use Figma MCP for frame structure, component properties, variables, styles, spacing, and assets.
- Prefer links to selected frames containing a `node-id`.
- Do not treat a screenshot as the only design source when structured Figma data is available.
- Save exported design assets under `assets/figma/` with descriptive kebab-case names.
- Do not use placeholders when the design contains an accessible asset.
- Preserve image aspect ratios and do not stretch raster images.
- When Figma has only desktop or only mobile, infer intermediate behavior conservatively.
- Record inferred responsive behavior in `docs/decisions.md`.
- Do not treat text shown in Figma as verified personal information when it conflicts with confirmed facts or the PDF.
- Use verified content while preserving the intended Figma layout.

## Content rules

- Read `docs/user-provided-facts.md` before extracting or rewriting page content.
- Extract factual content from the PDF for information that has not been superseded.
- Preserve spelling of names, dates, organization names, project names, URLs, and technical terms.
- Improve wording only when requested.
- Do not fabricate missing details.
- Use concise portfolio copy and keep full detail in the downloadable PDF when appropriate.
- The PDF is a source file and must not be modified.
- `docs/user-provided-facts.md` must not be modified without a factual reason.
- Information marked `UNVERIFIED` must not be presented publicly as confirmed.
- Sensitive information must be reviewed before publication.

Potentially sensitive information includes:

- personal phone number;
- personal email;
- home address;
- student ID;
- signatures;
- private document links;
- private repository links;
- authentication credentials.

## Experience date rules

Use explicit month and year when confirmed.

Examples:

- `June 2026 – August 2026`
- `June 2026 – Present`

Do not write `Present` unless the position is currently active according to a confirmed source.

When a future expected end date is provided:

- preserve the expected date;
- clearly distinguish it from a completed employment period;
- use wording such as `Expected August 2026` when appropriate;
- do not imply that the internship has already ended.

When two positions overlap:

- preserve both periods;
- do not assume one position replaced the other;
- ask the user if the employment relationship is unclear.

## Front-end implementation rules

- Use semantic HTML landmarks and a logical heading hierarchy.
- Keep CSS maintainable and responsive.
- Prefer fluid sizing with `clamp()`, `min()`, `max()`, `minmax()`, flexible grids, and intrinsic sizing.
- Avoid fixed page widths, fixed page heights, and positioning that only works at one viewport.
- Use JavaScript only for actual interaction.
- Preserve keyboard navigation, visible focus states, readable contrast, useful alt text, and reduced-motion behavior.
- Do not add a framework or production dependency without user approval.
- Do not rewrite the whole site when a focused change is sufficient.
- Keep secrets, access tokens, `.env` files, and local credentials out of the repository.
- Do not expose private source documents through website links unless explicitly approved.
- Keep the current HTML, CSS, and JavaScript stack unless the user explicitly approves a migration.

## Verification

After code changes:

1. Run:

   ```powershell
   powershell -ExecutionPolicy Bypass -File scripts/check-project.ps1
   ```
