# Blueprint Review Report

## Slug
br253

## Iteration
253

## Top-level summaries

### Proofs lacking detail

- `Picard_TensorObjSubstrate.tex` / `lem:pullback_val_iso_natural`: No proof body. The lemma block
  ends directly at `\end{lemma}` with no `\begin{proof}...\end{proof}`. Since the Lean declaration
  `pullbackValIso_hom_natural` is already axiom-clean (per PROGRESS.md), this is informational only —
  no prover needs to be guided through it — but the blueprint lacks a proof sketch for completeness.

### Citation discipline

No citation-discipline findings. All `% SOURCE:` blocks checked retain `(read from references/<file>.md)` 
parentheticals, and the files named match those listed in the writer reports.

---

## HARD GATE focus: `Picard_TensorObjSubstrate.tex`

### Directive confirmations

**1. D1' sketch no longer prescribes the whisker-exchange route: ✓ CONFIRMED.**

Lines 3324–3330: "The fourth square — the naturality of `sheafifyTensorUnitIso`
(`lem:sheafify_tensor_unit_iso_natural`) — is the one square that is *not* closed by the formal
monoidal interchange (whisker-exchange) law. …The square is instead closed by *descending to
sections*." The corrected proof sketch prescribes presheaf extensionality → module extensionality →
TensorProduct induction → sectionwise naturality of η on pure tensors. This section-level descent
route is mathematically sound and avoids the whisker-exchange path that prior analysis (whisker252)
showed is blocked by an instance-term split.

**2. `lem:sheafify_tensor_unit_iso_natural` proof body — faithful and formalizable: ✓ CONFIRMED.**

The three-step proof (lines 3367–3408) is concrete and prover-executable:
- Step 1: `PresheafOfModules.Hom.ext` reduces to componentwise equality over each open `U`.
  The `restrictScalarsId_map` strip reconciles the carrier spelling first.
- Step 2: `ModuleCat.hom_ext` + `TensorProduct` induction reduces to pure tensors `p ⊗ q`.
  The zero / additivity cases are formal because both composites are `𝒪_X(U)`-linear.
- Step 3: Pure-tensor identity splits as two independent naturality squares of the sheafification
  unit η, evaluated at p (resp. q); these hold because η is a natural transformation.

This is a faithful, element-level argument with named Mathlib tactics at each step. Not hand-waving.

**3. `homOfLocalCompat` sub-step (a) — concrete HEq → IsCompatible path: ✓ CONFIRMED.**

Lines 5802–5826 give a specific bridge:
- The overlap-agreement hypothesis is typed as `HEq` (the two double-restrictions reach the overlap
  by different slice routes, so their types are propositionally but not definitionally equal).
- `localSection i` conjugates components by `eqToHom`, landing them in the hom-sheaf `𝒣(V)`.
- Restricting `localSection i` to the overlap evaluates sectionwise to the component of `f_i`,
  conjugated by the `eqToHom` identifications.
- Both sides are transported into the common type `𝒣(Uᵢ ⊓ Uⱼ)` along those `eqToHom`s.
- The route-difference between the two restriction maps collapses via `Subsingleton.elim` on the
  thin poset `(Opens X)^op`.
- Heterogeneous agreement becomes genuine equality in `𝒣(Uᵢ ⊓ Uⱼ)`.

The `IsCompatible` condition is therefore exactly the assumed `HEq`-agreement, transported through
the `eqToHom`-conjugation and the `Subsingleton.elim` identification. Concrete and prover-executable.

**4. Broken `\ref`/`\uses`/`\cref` from the new blocks: ✗ FAILED — ONE BROKEN REFERENCE.**

The proof block of `lem:sheafify_tensor_unit_iso_natural` (added by bw253b) contains:

```latex
\begin{proof}
  \uses{lem:sheafify_tensor_unit_iso}
  Write Φ …assembled from the reconciliation isomorphism
  \(\mathtt{sheafifyTensorUnitIso}\) (\cref{lem:sheafify_tensor_unit_iso}) and so …
```

The label `lem:sheafify_tensor_unit_iso` (without `_natural`) **does not exist anywhere in the
blueprint** (confirmed by grepping all `\label{}` entries in the chapter and all sibling chapters —
full label list examined). The `sheafifyTensorUnitIso` Lean declaration is used extensively in the
chapter prose and proofs but has no dedicated labeled block.

This is a broken `\uses{}` cross-reference AND a broken `\cref{}` in the proof body.

**Severity**: must-fix-this-iter (broken `\uses{}` cross-reference per the severity rules).

**Fix**: The writer should either:
- **(Preferred)** Remove `\uses{lem:sheafify_tensor_unit_iso}` from the proof and replace the
  `\cref{lem:sheafify_tensor_unit_iso}` in the prose with the unlinked Lean name
  `\texttt{sheafifyTensorUnitIso}` (since the iso is an intermediate construction inside
  `lem:pullback_tensor_map`, not a separately labeled blueprint block), OR
- **(Alternative)** Add a thin labeled block for `sheafifyTensorUnitIso` (e.g.,
  `\label{lem:sheafify_tensor_unit_iso}`) in the appropriate place within the D1′ sub-section,
  pinning `\lean{AlgebraicGeometry.Scheme.Modules.sheafifyTensorUnitIso}`.

The bw253b writer's compliance note says "`\uses{}` honest & cycle-free" — this was incorrect; the
label genuinely does not exist.

**No dependency cycle**: None of the three new blocks (`lem:sheafify_tensor_unit_iso_natural`,
`lem:pullback_val_iso_natural`, `lem:scheme_modules_hom_local_section`) introduce any dependency
cycle. Their valid `\uses{}` targets are:
- `lem:sheafify_tensor_unit_iso_natural` proof: `lem:sheafify_tensor_unit_iso` (**broken**)
- `lem:pullback_val_iso_natural`: no `\uses{}` ✓
- `lem:scheme_modules_hom_local_section`: `lem:open_immersion_slice_sheaf_equiv` (line 5382) ✓
- `lem:sheafofmodules_hom_of_local_compat` proof: `def:scheme_modules_homMk` (5698), `lem:open_immersion_slice_sheaf_equiv` ✓

---

## Per-chapter

### `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
- **complete**: partial
- **correct**: partial
- **notes**:
  - **must-fix** — `\uses{lem:sheafify_tensor_unit_iso}` in proof of `lem:sheafify_tensor_unit_iso_natural`
    references a non-existent label; `\cref{lem:sheafify_tensor_unit_iso}` in the same proof is also
    broken. `lem:sheafify_tensor_unit_iso` has no `\label{}` definition anywhere in the blueprint.
    Fix: remove the `\uses{}`/`\cref{}` or add a thin labeled block for `sheafifyTensorUnitIso`.
  - informational — `lem:pullback_val_iso_natural` has no proof body (already axiom-clean in Lean;
    no prover needed, but the blueprint is incomplete for the block).

### `blueprint/src/chapters/Picard_LineBundlePullback.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_RelPicFunctor.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - Has `§~REF` cross-reference placeholders in the intro paragraph (unchanged from prior reviews;
    deferred, not on active dispatch). No must-fix: the held RPF lane is not dispatched this iter.

### `blueprint/src/chapters/Picard_RelativeSpec.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - `Theorem~REF` and `Section~REF` placeholders (11 instances from prior review; still deferred
    per PROGRESS.md; no active prover on this file this iter). Carry-over from prior deferral log.

### `blueprint/src/chapters/AbelianVarietyRigidity.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Rigidity.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RigidityKbar.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - Houses the fallback route-(a) artifact; `[CharZero]` dependency noted as intentional. Not on
    active dispatch. No new issues.

### `blueprint/src/chapters/Jacobian.tex` — complete + correct, no notes.

### `blueprint/src/chapters/AbelJacobi.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Genus.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_FGAPicRepresentability.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - A.2.c chapter; HELD, not on active dispatch. Standing partial: several Lean declarations pinned
    `[⟨sorry⟩]` constructors (intentional scaffolding). No new issues vs. prior review.

### `blueprint/src/chapters/Picard_QuotScheme.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - A.2.b chapter; HELD. Standing: small REF placeholder in paragraph referencing the flattening
    stratification sub-step. No new issues.

### `blueprint/src/chapters/Picard_IdentityComponent.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - A.3 chapter; gated A.2.c. No Lean file yet. Blueprint provides adequate specification but the
    consumer Lean file is not yet created. Not on dispatch. No new issues.

### `blueprint/src/chapters/Picard_Pic0AbelianVariety.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - A.3 chapter; gated A.2.c. No Lean file yet. Blueprint provides adequate specification. No new
    issues.

### `blueprint/src/chapters/Picard_FlatteningStratification.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 12 `REF` placeholders + missing `\lean{}` references (unchanged from prior reviews; deferred).
    HELD, not on active dispatch.

### `blueprint/src/chapters/Albanese_AlbaneseUP.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - A.4 chapter; gated A.2.c. No Lean file yet. Blueprint provides adequate Route-(ii) symmetric-power
    specification. No new issues.

### `blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - SOON finding from br251 (proof sketch incomplete) RESOLVED: the proof of
    `thm:rational_map_to_av_extends` now has a complete three-step proof body citing
    `thm:codim_one_extension` and `lem:milne_codim1_indeterminacy` with an explicit collapse
    argument. Proof is concrete and formalizable.

### `blueprint/src/chapters/Albanese_CodimOneExtension.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - Stacks 00TT depth gap (noted in prior review; deferred). No active prover. No new issues.

### `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 7 `REF` placeholders (Definition~REF, Theorem~REF, Corollary~REF, Section~REF); deferred per
    prior reviews. No active prover on this file this iter.

### `blueprint/src/chapters/Albanese_CoheightBridge.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - Helper chapter, not on active dispatch. No new issues observed in the portions read.

### `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - Route C PAUSED (USER). Standing partial issues unchanged from prior reviews. No new issues.

### `blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - Route C PAUSED (USER). File is a specification for a held lane. No new issues.

### `blueprint/src/chapters/RiemannRoch_RRFormula.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_OCofP.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_OcOfD.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_H1Vanishing.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - Route C PAUSED. No new issues observed.

### `blueprint/src/chapters/Cohomology_FlatBaseChange.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - HELD (defeq wall, per PROGRESS.md). No new issues.

### `blueprint/src/chapters/Cohomology_HigherDirectImage.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - HELD (Mathlib-absent `Rⁱf_*`). No new issues.

### `blueprint/src/chapters/Cohomology_MayerVietoris.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 4 REF placeholders (from prior review); deferred. No new issues.

### `blueprint/src/chapters/Cohomology_SheafCompose.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_StructureSheafAb.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 12 REF placeholders (unchanged from prior reviews); deferred. No new issues.

### `blueprint/src/chapters/Differentials.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 7 REF placeholders (unchanged from prior reviews); deferred. No new issues.

### `blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex` — complete + correct, no notes.

### `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex` — complete + correct, no notes.

---

## Severity summary

### Must-fix-this-iter

1. **`Picard_TensorObjSubstrate.tex` / `lem:sheafify_tensor_unit_iso_natural` proof — broken `\uses{}`
   and `\cref{}`**: `\uses{lem:sheafify_tensor_unit_iso}` and `\cref{lem:sheafify_tensor_unit_iso}`
   reference a label that does not exist anywhere in the blueprint. Introduced by bw253b.
   **Fix**: remove the `\uses{}` from the proof and replace `\cref{lem:sheafify_tensor_unit_iso}` with
   unlinked prose (e.g., `\texttt{sheafifyTensorUnitIso}`), OR add a thin labeled block for the
   declaration. This is a trivial editorial fix (one line change); mathematically, both occurrences
   correctly describe `sheafifyTensorUnitIso` — the issue is purely the missing label.
   **HARD GATE impact**: blocks dispatch of both `Picard/TensorObjSubstrate.lean` and
   `Picard/TensorObjSubstrate/DualInverse.lean` until cleared. Same-iter fast path available:
   dispatch blueprint-writer scoped to this single fix, then re-dispatch me (br-fix253) to confirm.

**Overall verdict**: HARD GATE FAILS for `Picard_TensorObjSubstrate.tex` — one broken `\uses{}`
reference in `lem:sheafify_tensor_unit_iso_natural` (added by bw253b) blocks prover dispatch for
both `TensorObjSubstrate.lean` and `DualInverse.lean`; 35 chapters audited; 1 must-fix finding;
0 unstarted-phase proposals. The fix is a trivial one-line editorial change; same-iter fast path
is recommended.
