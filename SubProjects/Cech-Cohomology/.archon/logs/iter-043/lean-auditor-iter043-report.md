# Lean Audit Report

## Slug
iter043

## Iteration
043

## Scope
- files audited: 1
- files skipped (per directive): 0 — directive explicitly scopes to one file (the only `.lean` modified this iter)

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 3 flagged (see notes)
- **excuse-comments**: none
- **notes**:
  - **[Line 732, 741 — deprecated API in both new lemmas]** Both `modulesSpecToSheaf_smul_eq`
    and `modulesRestrictBasicOpen_smul_eq` use `CategoryTheory.Sheaf.val` (via `.val.obj`),
    which the Lean diagnostic reports as deprecated: _"Use `ObjectProperty.obj`"_. The warnings
    fire at the `show F.val.obj ... from x` and `show F.val.obj ... from m` type ascriptions in
    the two `rfl` lemma bodies. No other part of the file triggers this deprecation warning
    (older lemmas appear to access `.presheaf` directly rather than `.val.obj`). **Major.**
  - **[Lines 813–845 — "PROVEN tactic prefix" over-claim in comment]** The block beginning
    _"and the following PROVEN tactic prefix reduces it to one residual goal"_ refers to a tactic
    sequence for `tile_scalar_compat`, a lemma that is never defined in this file (it exists only
    in the comment). The word "PROVEN" is a documentation over-claim: the tactics have not been
    type-checked against a compiled lemma statement in any scope that Lean accepts. The tactics
    may have been tested interactively and may well work — but the claim requires being reworded
    to something like "expected tactic prefix" or "tested (but not yet compiled) tactic prefix".
    The comment is otherwise accurate about the partial state of the section. **Major.**
  - **[Lines 730–735 — `modulesSpecToSheaf_smul_eq` rfl fragility]** The `rfl` is genuine:
    independently verified — axioms `{propext, Classical.choice, Quot.sound}`, no errors.
    However, the closing relies on the implicit definitional equality
    `(modulesSpecToSheaf.obj F).presheaf.obj (op W) = F.val.obj (op W)`, surfaced only through
    the `show F.val.obj (Opposite.op W) from x` type ascription. There is no comment explaining
    which Mathlib definitional path enables this equality. If `modulesSpecToSheaf` is re-defined
    to wrap sections differently, the `rfl` will silently break. **Minor** (currently sound,
    fragile under upstream changes).
  - **[Lines 740–750 — `modulesRestrictBasicOpen_smul_eq` rfl and comment tension]**
    The `rfl` is genuine: independently verified — same axiom set, no errors. The
    `show F.val.obj (op (ι ''ᵁ (iso.inv ''ᵁ ⊤))) from m` cast asserts that
    `(modulesRestrictBasicOpen g F).val.obj (op ⊤)` is definitionally equal to
    `F.val.obj (op (iterated image))` — i.e. the carrier types of the restricted and original
    sections coincide. The `TileSectionLocalization` section header (lines 713–715) states
    "`modulesSpecToSheaf.obj` does NOT commute with restriction **definitionally**", which a
    reader could take as contradicting this `rfl`. The distinction — the header addresses the
    _section-comparison linear map_ not being rfl, while this lemma asserts a _carrier-type_
    definitional equality together with a specific _scalar-action formula_ — is undocumented.
    Without an explanatory comment, future maintainers may either distrust this `rfl` (treating
    it as dubious given the header) or, worse, interpret the header as overstated. **Minor**
    (valid but confusing).
  - **[Lines 708, 713, 801, 857–860 — line-length lint warnings]** Six lines inside
    `TileSectionLocalization` long-line-linter warnings (>100 chars). All are inside the large
    planning comment; none affect compiled code. **Minor.**

---

## Must-fix-this-iter

None. Every compiled declaration in the file is axiom-clean
(`{propext, Classical.choice, Quot.sound}` only), no sorry, no fake bodies, no weakened
definitions, no parallel-API constructions. The two `rfl`-bodied lemmas are genuine
definitional equalities confirmed by independent LSP verification.

---

## Major

- `QcohTildeSections.lean:732` — `modulesSpecToSheaf_smul_eq` uses deprecated
  `CategoryTheory.Sheaf.val` (`.val.obj` in the `show` ascription). Lean diagnostic:
  _"Use `ObjectProperty.obj`"_. The deprecated field is referenced in the type of the
  `show` ascription that makes the `rfl` typecheck; once Lean removes the alias this
  lemma will fail to compile. Should be updated to the canonical accessor before the
  deprecation is removed upstream.

- `QcohTildeSections.lean:741` — `modulesRestrictBasicOpen_smul_eq` has the same deprecated
  `.val.obj` usage in its `show` ascription (two occurrences on line 741 and line 747).
  Same fix needed.

- `QcohTildeSections.lean:813` — Comment claims _"the following PROVEN tactic prefix reduces
  it to one residual goal"_ for `tile_scalar_compat`, which is never compiled in this file.
  The tactics have not been type-checked against the actual lemma statement. The word
  "PROVEN" over-claims what has been verified. Reword to "expected" / "tested but not yet
  compiled" to avoid the reader trusting a proof status that hasn't been established.

---

## Minor

- `QcohTildeSections.lean:730–735` — `modulesSpecToSheaf_smul_eq`: the `rfl` exploits
  `(modulesSpecToSheaf.obj F).presheaf.obj (op W) = F.val.obj (op W)` definitionally, with
  no comment explaining which definition(s) give this equality. Fragile under Mathlib
  refactors of `modulesSpecToSheaf`.

- `QcohTildeSections.lean:740–750` — `modulesRestrictBasicOpen_smul_eq`: the `show ... from m`
  carrier cast implies a definitional equality that appears to be in tension with the section
  header claim at lines 713–715. The distinction (map vs. carrier, section-comparison vs.
  scalar-action formula) is undocumented. Add a one-line comment explaining why the `rfl` is
  valid despite the header's "does NOT commute definitionally" warning.

- `QcohTildeSections.lean:708,713,801,857–860` — Six line-length lint warnings inside comment
  blocks; no compiled-code impact.

---

## Excuse-comments (always called out separately)

None. The `TileSectionLocalization` comment block is a roadmap for future work, not an excuse
for present wrong code. The compiled lemmas in the section (`tile_image_opens_identities`) are
axiom-clean. The future-lemma stubs exist only in comments, not as `sorry`-bodied definitions.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 3 (two deprecated-API uses in the new `rfl` lemmas; one documentation over-claim)
- **minor**: 4 (two underdocumented `rfl` fragilities; one comment–header tension; line-length warnings)
- **excuse-comments**: 0

Overall verdict: The file is axiom-clean and both new `rfl`-bodied lemmas are genuine
definitional equalities (independently verified); the three major findings are the two
deprecated `CategoryTheory.Sheaf.val` usages that will eventually break the build when the
alias is removed, and the "PROVEN" over-claim in the planning comment block.
