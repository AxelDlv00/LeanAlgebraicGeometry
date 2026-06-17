# Blueprint Review Report

## Slug
routeb

## Iteration
036 (same-iter fast-path re-review)

## Scope
Full blueprint audit per instructions, with primary focus on the new Route B section of
`Cohomology_CechHigherDirectImage.tex` and its gate decision.

---

## Top-level summaries

### Dependency & isolation findings

- **Isolated node** (leandag): one `lean_aux` node (`lean:Alg…`, type `lean_aux`, no chapter).
  **keep** — an uncovered Lean helper, not a blueprint node. No action required.

- `lem:qcoh_section_isLocalizedModule` statement block has `lem:fromTildeGamma_mathlib` in its
  `\uses{}` but the proof block's `\uses{}` does NOT include it. The `fromTildeGamma_mathlib` is
  used in the assembly lemma (`lem:qcoh_isIso_fromTildeGamma`), not in the keystone's proof body.
  This is a spurious dependency in the statement block's `\uses{}` — it adds a thematic context
  pointer but not a logical prerequisite. **wire-up direction**: remove `lem:fromTildeGamma_mathlib`
  from the statement-block `\uses{}` of `lem:qcoh_section_isLocalizedModule`. (Soon-severity
  only — it does not break the gate, but it misrepresents the DAG edge and could mislead
  leandag dispatch order if `fromTildeGamma_mathlib` were ever not-yet-done.)

- **`unmatched_lean`**: 35+ nodes are unmatched. All are either `\mathlibok` declarations
  (expected: they live in Mathlib, not the local tree) or project-to-build targets without
  `\leanok` yet (`qcoh_section_isLocalizedModule`, `isIso_fromTildeΓ_of_quasicoherent`, etc.).
  No action required — expected state for not-yet-dispatched Route B targets.

---

## Gate verdicts

### lem:qcoh_section_isLocalizedModule — GATE: PASS

**Statement** (lines 3927–3956): For quasi-coherent `F` on `Spec R` and `f ∈ R`, the
section-restriction map `ρ_f : Γ(X,F) → Γ(D(f),F)` is
`IsLocalizedModule (.powers f) ρ_f`. This is a correct generalization of Tag 01HV(4)
from `~M` to arbitrary quasi-coherent `F`, and is the single load-bearing input of Route B.

**Proof sketch quality**: The three-step argument is rigorous and formalizable:
1. Finite standard-cover refinement via `lem:exists_finite_basicOpen_subcover` ✓
2. On each `D(g_j)`, the quasi-coherence datum gives `F|_{D(g_j)} ≅ ~M_j`; the
   free-piece section-restriction is the structure-sheaf localization map
   (via `lem:free_isQuasicoherent` and `~toOpen`); Čech acyclicity
   (`lem:cech_acyclic_affine`) confirms that sections over the cokernel presentation are
   right-exact, making the localized map `(ρ_f)_{g_j}` an
   `IsLocalizedModule (.powers f)` ✓
3. `lem:isLocalizedModule_of_span_cover` descent over the spanning `{g_j}` ✓

**`\uses{}` accuracy**: Statement block lists
`{lem:isLocalizedModule_of_span_cover, lem:exists_finite_basicOpen_subcover,
lem:free_isQuasicoherent, lem:cech_acyclic_affine, lem:fromTildeGamma_mathlib}`.
The proof block lists the same minus `lem:fromTildeGamma_mathlib`. All four proof-block
deps are axiom-clean per the project journal. The extra `lem:fromTildeGamma_mathlib` in
the statement block is spurious (see isolation finding above) but not a correctness error.

**Lean target**: `AlgebraicGeometry.qcoh_section_isLocalizedModule` — correctly named,
consistent with the project namespace convention, and confirmed to-build (no `\leanok`,
marked `% NOTE: to-build` in the block).

### lem:qcoh_isIso_fromTildeGamma — GATE: PASS

**Statement** (lines 3990–4019): For quasi-coherent `F` on `Spec R`, the counit
`fromTildeΓ : ~(Γ(X,F)) → F` is an isomorphism. This is the unconditional 01I8 result
that discharges the `[IsIso F.fromTildeΓ]` hypothesis of `lem:qcoh_iso_tilde_sections`.

**Assembly logic** (lines 4020–4040): Sound in three steps:
1. `lem:forget_reflectsIso_mathlib` + `{D(f)}` basis → sufficient to check each component
2. `lem:fromTildeGamma_mathlib` identifies the `D(f)`-component as the localization lift
3. Keystone `lem:qcoh_section_isLocalizedModule` + `lem:isLocalizedModule_linearEquiv_mathlib`
   → both sides of the lift are localizations of `Γ(X,F)` at powers of `f` → lift is iso

No circularity: the chain is Route B keystone → `isIso_fromTildeΓ_of_quasicoherent` →
`qcoh_iso_tilde_sections` → `affine_cech_vanishing_qcoh` → `affine_serre_vanishing`; the
02KG affine vanishing is strictly downstream. DAG confirmed acyclic by `leandag`
(`conflicts: []`, `unknown_uses: []`).

---

## Mathlib anchor verification (`\mathlibok` blocks)

All four anchors in the Route B section verified live against the project's Lean toolchain:

| Label | `\lean{}` pin | Lean type signature (observed) | Match? |
|---|---|---|---|
| `lem:fromTildeGamma_mathlib` | `AlgebraicGeometry.Scheme.Modules.fromTildeΓ` | `AlgebraicGeometry.tilde ((AlgebraicGeometry.modulesSpecToSheaf.obj M).presheaf.obj (Opposite.op ⊤)) ⟶ M` — the counit `~(Γ(SpecR,M)) → M` | **PASS** |
| `lem:isIso_fromTildeGamma_iff_mathlib` | `AlgebraicGeometry.isIso_fromTildeΓ_iff` | `CategoryTheory.IsIso M.fromTildeΓ ↔ (AlgebraicGeometry.tilde.functor R).essImage M` | **PASS** |
| `lem:forget_reflectsIso_mathlib` | `SheafOfModules.fullyFaithfulForget` | `(SheafOfModules.forget R).FullyFaithful` — fully faithful hence reflects isos | **PASS** |
| `lem:isLocalizedModule_linearEquiv_mathlib` | `IsLocalizedModule.linearEquiv` | `[IsLocalizedModule S f] [IsLocalizedModule S g] : M' ≃ₗ[R] M''` — canonical linear equiv between two localizations at same submonoid | **PASS** |

Note on `lem:forget_reflectsIso_mathlib`: The proof block claims that checking on the
basis of `{D(f)}` is sufficient. This uses (a) `fullyFaithfulForget` (reflects isos)
and (b) the standard fact that a sheaf morphism that is an iso on a basis of opens is a
global iso. Fact (b) is not pinned in the `\lean{}` field. This is a minor
under-specification; the prover will need to source it separately (Mathlib provides this
via `CategoryTheory.Presheaf.isIso_of_locallyIso` or similar). Flag as **informational**.

---

## Secondary checks

**`% archon:covers AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean` header**:
PRESENT at line 13 of `Cohomology_CechHigherDirectImage.tex`. ✓

**Route-A dormant labeling**: All six Route-A blocks are clearly marked:
- `lem:modules_restrict_basicOpen` (line 4218): *"Route-A fallback: this block and the
  restriction-to-basic-open base-change chain it heads are superseded on the live 01I8 path..."*
- `lem:tilde_restrict_basicOpen` (line 4294): *"Route-A fallback (tilde base-change), off the live
  01I8 path..."*
- `lem:presentation_restrict_basicOpen` (line 4333): *"Route-A fallback (P1a base-change chain),
  off the live 01I8 path..."*
- `lem:isQuasicoherent_restrict_basicOpen` (line 4378): *"Route-A fallback (P1a base-change chain),
  off the live 01I8 path; the live keystone Lemma lem:qcoh_section_isLocalizedModule..."*
- `lem:tilde_preserves_kernels` (line 4588): *"Route-A fallback: ... kept as dormant axiom-clean
  assets, off the live 01I8 path..."*
- `lem:isIso_fromTildeGamma_of_quasicoherent` (line 4793): *"This is the Route-A
  (global-generation) proof of the 01I8 counit isomorphism; it is a dormant fallback
  superseded by the live section-localization assembly..."*
- `rem:o1i8_decomposition` explicitly identifies "Route A (dormant fallback)" as a separate
  sub-section.

None of these blocks create false frontier readiness — they have no `\leanok` on the
unfinished proof bodies and are clearly labelled as off-path. ✓

**TildeExactness helpers coverage debt**: The four helpers `stalkMapₗ`, `stalkMapₗ_eq`,
`stalkMapₗ_injective`, `tilde_germ_algebraMap_smul` already appear in the `\lean{}`
field of `lem:tilde_preserves_kernels` (line 4567). They are properly positioned as
dormant Route-A sub-declarations. No further action needed this iter; planner may wire
their `\lean{}` entries once/if Route A is reactivated.

---

## Rendering & dependency integrity

**Blueprint-doctor**: zero `malformed_refs`, zero `broken_refs`, zero orphan chapters, no
`covers_problems`. All three chapters present and included. ✓

**leandag**: `unknown_uses: []` (no broken `\uses{}` cross-references). `conflicts: []`.
One isolated node (`lean_aux` type, no chapter — **keep**). All `unmatched_lean` entries
are expected `\mathlibok` Mathlib declarations or not-yet-dispatched project targets. ✓

---

## Per-chapter

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - *Informational* — `lem:qcoh_section_isLocalizedModule` statement block has a spurious
    `lem:fromTildeGamma_mathlib` in its `\uses{}` that does not correspond to a proof
    dependency (it is used by the assembly lemma, not the keystone). **wire-up**: remove it
    from the keystone's statement-block `\uses{}` when convenient (soon, not blocking).
  - *Informational* — `lem:forget_reflectsIso_mathlib` pin names `fullyFaithfulForget` (fully
    faithful → reflects isos) but the proof also implicitly uses "iso on basis of opens → global
    iso"; this second fact is not pinned. Low risk for a prover familiar with Mathlib sheaf
    theory, but could be noted for completeness.
  - *Note* — `lem:affine_serre_vanishing` (the 02KG top theorem) is in `unmatched_lean` because
    `AlgebraicGeometry.affine_serre_vanishing` has not yet been closed (gated on 01I8 close).
    This is expected; the blueprint is correctly structured to gate it.
  - *Note* — `lem:absolute_cohomology_pos_vanishing` and `lem:cech_to_cohomology_on_basis` carry
    explicit `[EnoughInjectives X.Modules]` instance hypotheses, consistent with the P5a
    convention documented in the chapter and memory. ✓

---

## Severity summary

**must-fix-this-iter**: none.

**soon** (1 finding):
- `Cohomology_CechHigherDirectImage.tex` / `lem:qcoh_section_isLocalizedModule`: spurious
  `lem:fromTildeGamma_mathlib` in the statement-block `\uses{}` (not a proof dependency).
  **wire-up**: remove that edge. Does not block the gate or any prover dispatch.

**informational** (2 findings):
- `lem:forget_reflectsIso_mathlib`: the "iso on basis → global iso" fact is not separately
  pinned in `\lean{}`; the prover must source it from Mathlib independently.
- TildeExactness helpers (`stalkMapₗ` etc.) are already in the `\lean{}` of the dormant
  `lem:tilde_preserves_kernels` block; no action needed until/unless Route A is reactivated.

---

Overall verdict: **Route B section is complete and correct; both gate lemmas PASS —
dispatch prover to `AlgebraicJacobian/Cohomology/QcohTildeSections.lean` targeting
`lem:qcoh_section_isLocalizedModule` (`AlgebraicGeometry.qcoh_section_isLocalizedModule`)
is cleared; 3 chapters audited, 3 findings (0 must-fix, 1 soon, 2 informational),
0 unstarted-phase proposals.**
