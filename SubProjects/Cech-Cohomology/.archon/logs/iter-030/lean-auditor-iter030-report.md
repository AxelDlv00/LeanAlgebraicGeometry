# Lean Audit Report

## Slug
iter030

## Iteration
030

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/FreePresheafComplex.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (see notes)
- **excuse-comments**: none
- **notes**:
  - **`set_option linter.unusedSectionVars false` at line 1464** (inside `section FamilyParameterized`).
    The section declares `{ι : Type u} [Finite ι] (U : ι → Opens X)`. The option suppresses linter
    warnings for declarations in the section that do not syntactically use `[Finite ι]` — examples
    are the pure order/lattice lemmas `coverInterOpenFam`, `coverInterOpen_comp_leFam`,
    `le_coverInterOpen_iffFam`, `survivingEquivFam`.  These genuinely do not need finiteness.
    `[Finite ι]` IS load-bearing for the coproduct/evaluation declarations: `cechFreeEval_XFam`
    (line ~1657) explicitly invokes `PresheafOfModules.Finite.evaluation_preservesFiniteColimits`
    inside an `infer_instance` call for `PreservesColimitsOfShape (Discrete (Fin (p+1) → ι))`,
    which requires finiteness of `Fin (p+1) → ι`, hence of `ι`.  The option is technically
    appropriate but means future additions to the section will not be warned if they accidentally
    drop `[Finite ι]` from a definition that needs it. Minor code smell; currently correct.
  - **`cechFreeComplex_quasiIsoFam` (lines 2341–2351)** — the headline theorem is genuine and
    non-vacuous.  The `QuasiIso` target is `coverStructurePresheafFam U` (the image presheaf of the
    augmentation, line 1564–1566), NOT the full structure sheaf `O_X`.  There is NO covering
    hypothesis (`⊤`, `iSup`, or "U covers X") anywhere in the chain.  The two proof cases are:
    (a) `∃ i, W ≤ U i`: contractibility via `cechFreeEval_quasiIso_of_nonemptyFam`; (b)
    `∀ i, ¬(W ≤ U i)`: both sides zero via `cechFreeEval_quasiIso_of_isEmptyFam`.  Both cases are
    handled without any covering side-condition. The statement is mathematically honest: the free
    complex resolves whatever it covers (its own image presheaf).
  - **Large strategy comment block, lines 44–100** — documents DEAD END approaches ("DEAD END — do
    NOT hand-roll…"). Not an excuse-comment; accurate historical documentation. Verbose but not
    misleading.
  - **Fam section code duplication (~lines 1462–2352)** — roughly 890 lines mechanically
    re-parameterizing the OpenCover-indexed (~lines 113–1449) declarations by substituting
    `𝒰.I₀ ↦ ι`, `coverOpen 𝒰 ↦ U`, `coverInterOpen 𝒰 ↦ coverInterOpenFam`. This is an explicit
    design choice (per code comment at lines 1455–1460: "The `X.OpenCover`-named declarations above
    are kept byte-identical (so `CechBridge.lean` stays green)"). Not a bug, but a notable
    structural weight.
  - **`rfl` proofs on degreewise-unfolding lemmas** (`cechFreePresheafComplex_X` line 218,
    `cechFreePresheafComplex_XFam` line 1544) — both hold definitionally by how the complex is
    assembled from `alternatingFaceMapComplex`. These `rfl` proofs are legitimate.
  - **`sigma_ι_eqToHom_transport` (line 150)** — private helper for the simplicial-identity
    bookkeeping. `subst e; simp` is the correct proof.
  - No `sorry`, no `:= True`, no `:= Classical.choice _` on substantive claims in either the
    OpenCover section or the FamilyParameterized section. All proofs are substantive tactic proofs.

---

### AlgebraicJacobian/Cohomology/QcohTildeSections.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **`free_isQuasicoherent` (instance, lines 101–105)** — genuine instance.  Pattern:
    `prop_of_iso (tildeFinsupp ι) inferInstance` where `tildeFinsupp` is the Mathlib isomorphism
    `SheafOfModules.free ι ≅ tilde (ι →₀ R)` and `inferInstance` infers that `tilde (ι →₀ R)` is
    quasi-coherent (it is in the essential image of `tilde.functor`).  Correct and non-vacuous.
  - **`isIso_fromTildeΓ_of_genSections` (lemma, lines 116–120)** — genuine: explicitly builds
    `F.Presentation := { generators := σ, relations := τ }` from the two supplied generating
    families and passes it to Mathlib's `isIso_fromTildeΓ_of_presentation`.  The hypotheses
    `σ : F.GeneratingSections` and `τ : (kernel σ.π).GeneratingSections` must be supplied by the
    caller — the blocked step-1 fact (`[IsQuasicoherent F] → ∃ σ`) is NOT inferred anywhere.
  - **`qcoh_iso_tilde_sections_of_genSections` (def, lines 129–133)** — genuine: uses
    `isIso_fromTildeΓ_of_genSections` as a `haveI` to produce `[IsIso F.fromTildeΓ]` then returns
    `(asIso F.fromTildeΓ).symm`.  Correct.
  - **`qcoh_iso_tilde_sections` (conditional form, line 62–64)** — two-line: `(asIso F.fromTildeΓ).symm`.
    The `[IsIso F.fromTildeΓ]` hypothesis is stated explicitly in the typeclass position; the
    blocked step-1 (`[IsQuasicoherent F] → IsIso F.fromTildeΓ`) is NOT hidden.
  - **`@[simp]` lemmas at lines 77–86** — both hold by `rfl` (structural unfolding of `Iso.symm`).
    Legitimate `rfl` proofs.
  - **The Handoff comment (lines 135–180)** — explicitly and accurately documents: (a) steps 2–3
    are now formalised by `isIso_fromTildeΓ_of_genSections` / `qcoh_iso_tilde_sections_of_genSections`;
    (b) step 1 (affine global generation / localisation-of-sections, ~few-hundred LOC) is the
    single remaining mathematical blocker; (c) even step 2's "kernel is qcoh" sub-step is
    flagged as non-trivial (depending on step 1).  The blockers are stated honestly.
  - **Does the file silently assume the blocked step?**  No.  Every declaration that discharges
    `IsIso F.fromTildeΓ` requires either `[IsIso F.fromTildeΓ]` as an explicit typeclass
    hypothesis, or explicit `σ : F.GeneratingSections` + `τ : (kernel σ.π).GeneratingSections`
    as term hypotheses, or a concrete `F.Presentation`.  There is no path from `[IsQuasicoherent F]`
    alone to any conclusion in this file.
  - No `sorry`, no vacuous proofs, no excuse-comments.

---

## Must-fix-this-iter

*(none)*

---

## Major

*(none)*

---

## Minor

- `FreePresheafComplex.lean:1464` — `set_option linter.unusedSectionVars false` in
  `section FamilyParameterized` suppresses warnings for all section variables, including
  `[Finite ι]`, on declarations that don't syntactically use them.  Currently correct
  (the declarations that don't mention `[Finite ι]` genuinely do not need it, and the ones
  that do have it auto-included from the section).  Risk: future additions to the section
  could accidentally omit `[Finite ι]` from a proof path that needs it and receive no linter
  signal.  Consider documenting explicitly which non-Fam declarations do NOT need the
  finiteness hypothesis (or moving them to a sub-section without `[Finite ι]`).

- `FreePresheafComplex.lean:1462–2352` — The `section FamilyParameterized` block is ~890
  lines of near-verbatim re-parameterization of the ~1300-line OpenCover section.  This is a
  documented design choice (keeping OpenCover declarations byte-identical for `CechBridge.lean`
  compatibility), but creates a maintenance surface: every fix to an OpenCover declaration
  must be mirrored in the Fam variant.  Low risk short-term; worth tracking as a future
  refactor target once the bridge proofs stabilize.

- `FreePresheafComplex.lean:44–100` — The in-file strategy comment (Planner strategy block)
  is very long (~57 lines) and contains DEAD END annotations.  This is informative but is
  module-header material; if/when the file is submitted upstream, this block should be pruned
  to standard docstring format.  Not a correctness concern.

---

## Excuse-comments (always called out separately)

*(none)*

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: Both files are axiom-clean, substantive, and honest about their open hypotheses;
the FamilyParameterized section in FreePresheafComplex.lean correctly delivers a covering-hypothesis-free
`QuasiIso` over `coverStructurePresheafFam`, and QcohTildeSections.lean correctly formalizes steps 2–3
of the 01I8 decomposition without silently assuming the blocked step-1 affine global-generation theorem.
