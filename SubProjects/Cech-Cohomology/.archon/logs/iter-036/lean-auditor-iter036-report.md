# Lean Audit Report

## Slug
iter036

## Iteration
036

## Scope
- files audited: 1 (directive-scoped to `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`)
- files skipped per directive: all others — this iter's directive is single-file

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (minor — unused `with`-witness names)
- **excuse-comments**: none
- **notes**:

  **Axiom cleanliness — all three new lemmas**
  - `tilde_section_isLocalizedModule` (L408): axioms = `{propext, Classical.choice, Quot.sound}`. No `sorry`.
  - `section_isLocalizedModule_of_isIso_fromTildeΓ` (L441): axioms = `{propext, Classical.choice, Quot.sound}`. No `sorry`.
  - `section_isLocalizedModule_of_presentation` (L498): axioms = `{propext, Classical.choice, Quot.sound}`. No `sorry`.
  - LSP diagnostics: zero errors, zero warnings on the whole file.

  **Non-vacuousness of the three new lemmas**
  - All three state genuine `IsLocalizedModule (Submonoid.powers f) <restriction-map>` conclusions. The restriction map is
    the concrete `(modulesSpecToSheaf.obj …).presheaf.map (homOfLE le_top).op).hom` — a real `R`-linear map, not trivially
    definitionally equal to `id` or a constant.
  - `tilde_section_isLocalizedModule`: proof goes through `tilde.toOpen_res`, a `LinearEquiv` transport, and
    `IsLocalizedModule.of_linearEquiv_right` — substantive.
  - `section_isLocalizedModule_of_isIso_fromTildeΓ`: uses naturality of `β` at two opens + two `LinearEquiv` transports
    + instance synthesis; non-trivial chain.
  - `section_isLocalizedModule_of_presentation`: one line (`haveI` + delegation) — but it is a genuine conclusion
    under the real `F.Presentation` hypothesis.
  - No `True`-collapse, no `:= rfl` on a non-trivial goal, no trivial `simp` collapsing the predicate.

  **Section-comment count mismatch (L382 / L388)**
  - The `/-! ## Project-local Mathlib supplement — Route B local model …` header (L382) reads:
    > "The **two** declarations here are the **local model** of that statement"
  - The `section LocalModel` block now contains **three** declarations (the two pre-existing ones plus
    `section_isLocalizedModule_of_presentation` added this iter). The "two" count is stale.

  **"Keystone" overclaim in `section_isLocalizedModule_of_presentation` docstring (L489-492)**
  - The docstring opens: "**Route B keystone, globally-presented case.** … This is the keystone
    `qcoh_section_isLocalizedModule` for the special — but key — case of a global presentation."
  - `qcoh_section_isLocalizedModule` was intentionally NOT formalized (as acknowledged in the directive
    and in the `/-! ## Handoff -/` section). The phrase "This is the keystone" applied to a *special
    case* of the unconditional statement is semantically contradictory: if it were the keystone it would
    not be a special case. Using "keystone" for a stepping stone conflates the two, and a skimming reader
    may wrongly believe the keystone was closed.
  - The phrasing should be something like "**Route B local-model, globally-presented case** … This is the
    principal special case feeding the keystone `qcoh_section_isLocalizedModule`."

  **Unused `with`-witness names (minor)**
  - Several `set … with h` witnesses introduced in `section_isLocalizedModule_of_isIso_fromTildeΓ` are
    never referenced by name after definition:
    - `hM` (L446): `M = moduleSpecΓFunctor.obj F` — never used by name.
    - `hα` (L447): `α = qcoh_iso_tilde_sections F` — never used by name.
    - `hβ` (L449): `β = …` — never used by name.
    - `heTop` (L458): `eTop = …` — never used by name (contrast with `heTop` at L414 in the prior lemma,
      which IS used at L423).
    - `heDf` (L460): `eDf = …` — never used by name.
  - These are harmless (Lean 4 does not warn about unused `set`-witnesses), but they add noise. The
    `haveI hbrick` (L462) and `haveI hφloc` (L465) ARE consumed via implicit instance synthesis — not dead.

  **`haveI hbrick` and `haveI hφloc` — instance-synthesis pattern is correct**
  - `hbrick` (L462) feeds `IsLocalizedModule.of_linearEquiv_right` at L467.
  - `hφloc` (L465) feeds `IsLocalizedModule.of_linearEquiv` at L487.
  - Both are genuinely load-bearing even though never referenced by explicit name after definition.

  **Long-line lint**
  - Multiple docstring / comment lines exceed 100 chars (L114, L123, L207, L396, L402, L413, L433, L449,
    L464, L489–492, L551). None of these are tactic lines and none are structurally harmful, but the
    project's default 100-char limit is systematically violated in docstrings throughout this file.
    Cosmetic only given context, but worth a one-pass clean-up.

  **Module header (L9-44) accuracy**
  - The header accurately describes the conditional/presentation forms as the file's deliverables and
    clearly names `[IsQuasicoherent F] → IsIso F.fromTildeΓ` as the remaining gap.
  - The `## Handoff` section (L508-553) is accurate and up-to-date; "Steps 2–3 are now formalised" is
    correct.
  - The `/-! ### Reduction to global generation …` section (L89-98) and `/-! ### Route P, step 0 -/`
    section (L136-141) are both accurate.

---

## Must-fix-this-iter

None. No `sorry`, no unauthorized axioms, no vacuous conclusions, no excuse-comments, no weakened-wrong definitions.

---

## Major

- `QcohTildeSections.lean:388` — section-comment says "**two** declarations" but `section LocalModel`
  now contains **three** (`tilde_section_isLocalizedModule`, `section_isLocalizedModule_of_isIso_fromTildeΓ`,
  `section_isLocalizedModule_of_presentation`). Stale count misleads a reader about the section's scope.

- `QcohTildeSections.lean:489-492` — `section_isLocalizedModule_of_presentation` docstring calls this
  "the keystone `qcoh_section_isLocalizedModule` for the special … case". `qcoh_section_isLocalizedModule`
  was intentionally NOT formalized; calling a special case "the keystone" is a contradiction that
  overstates what is proven.

---

## Minor

- `QcohTildeSections.lean:446-460` — five `with h` witnesses (`hM`, `hα`, `hβ`, `heTop` at L458,
  `heDf`) are never referenced by name after definition. Harmless but noisy.

- `QcohTildeSections.lean` (multiple) — docstring lines exceed 100 chars at ~14 locations (L114, L123,
  L207, L396, L402, L413, L433, L449, L464, L489, L490, L492, L551). Cosmetic lint.

---

## Excuse-comments (always called out separately)

None found.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 2
- **excuse-comments**: 0

Overall verdict: The file is axiom-clean and all three new lemmas are genuine, non-vacuous `IsLocalizedModule`
statements; the only issues are two documentation inaccuracies (stale "two declarations" count, and
"keystone" overclaim on a special case) that could mislead readers of the section header and docstring.
