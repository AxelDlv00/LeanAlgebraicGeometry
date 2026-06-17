# Blueprint Review Report

## Slug
ts220fp

## Iteration
220

---

## Top-level summaries

### Incomplete parts

- `Picard_TensorObjSubstrate.tex` / `lem:presheaf_internal_hom_restriction`: the statement's `\uses{def:presheaf_internal_hom_value, def:presheaf_internal_hom}` creates a **cycle** with `def:presheaf_internal_hom`'s own `\uses{..., lem:presheaf_internal_hom_restriction}`. The restriction map is logically prior to the assembled presheaf; `def:presheaf_internal_hom` must not appear in the statement's `\uses{}`. Fix: change to `\uses{def:presheaf_internal_hom_value}` (or additionally `def:presheaf_internal_hom_slice_value` which it also implicitly depends on).

- `AlgebraicJacobian_Cotangent_GrpObj.tex`: pointer-only file with 0 formal declaration blocks; content redirected to `RigidityKbar.tex`. No prover active on this lane; recorded as structural stub.

- `RiemannRoch_OcOfD.tex`, `RiemannRoch_OCofP.tex`, `RiemannRoch_RRFormula.tex`: extensive bare `REF` placeholders in live prose (38/38/38 occurrences); cross-reference wiring incomplete. Route C PAUSED; no active prover; writer needed once lane de-gates.

- `Albanese_AuslanderBuchsbaum.tex`: 36 bare `REF` placeholders in live prose. Route-1 EXCISED/HELD; no active prover.

- `Picard_FlatteningStratification.tex`: 10 decl blocks but only 4 `\leanok`; 6 blocks without proof closure. HELD (gated A.2.c); no active prover.

- `Albanese_CodimOneExtension.tex`: 18 decls, 9 `\leanok`; `\uses{}` references Kähler-module lemmas (`lem:module_free_kaehler_localization`, `lem:rank_kaehler_localization_eq_relative_dim`) with no apparent home chapter — potentially dangling. Route-1 EXCISED/HELD.

- `Albanese_Thm32RationalMapExtension.tex`: 2 decl blocks, 1 `\leanok`; effectively a thin chapter missing full proof detail. Route-1 EXCISED/HELD.

### Proofs lacking detail

- `Picard_RelPicFunctor.tex`: placeholder bodies (`PicSharp := const PUnit`, `functorial := 0`) noted in PROGRESS.md as dishonest; the chapter's proof sketches for these blocks are correspondingly incomplete. HELD; re-engage gate explicitly noted in PROGRESS.md.

### Citation discipline

All `% SOURCE:` entries in the three new `sec:tensorobj_dual_infra` blocks cite `references/stacks-modules.tex` — confirmed to exist on disk. `% SOURCE QUOTE:` blocks present and in verbatim English matching the source language (Stacks is English). Visible `\textit{Source: ...}` lines present for all externally-sourced blocks. No fabrication detected.

---

## Per-chapter

### `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - **MUST-FIX (gate-blocking)**: `lem:presheaf_internal_hom_restriction` statement carries `\uses{def:presheaf_internal_hom_value, def:presheaf_internal_hom}`. Since `def:presheaf_internal_hom` itself carries `\uses{..., lem:presheaf_internal_hom_restriction}`, this creates a cycle in the `\uses{}` dependency graph. Fix: remove `def:presheaf_internal_hom` from the lemma statement's `\uses{}`; correct value is `\uses{def:presheaf_internal_hom_value}` (and optionally `def:presheaf_internal_hom_slice_value`, which the restriction map implicitly uses). The proof body at line 2565 already has the correct `\uses{def:presheaf_internal_hom_value}` — only the statement `\uses{}` needs the fix.
  - **Mathematical content of the three new blocks (gate question)**: correct and self-consistent.
    - `def:presheaf_internal_hom_value` (`homModule`): the post-composition R(T)-scalar action on Hom(M,N) is correct; the ring-homomorphism claim `f ↦ m_f^N` holds because R is commutative (m_{fg} = m_f ∘ m_g exactly). The fixed-ring vs. varying-ring distinction is called out accurately.
    - `def:presheaf_internal_hom_slice_value` (`internalHomObjModule`): the slice C/U has terminal `Over.mk(id_U)` at which R evaluates to R(U); specializing `homModule` gives the R(U)-module on `M|_U → N|_U`. Correct.
    - `lem:presheaf_internal_hom_restriction` (`restrictionMap`): the semilinearity claim `(f·φ)|_V = R(g)(f)·(φ|_V)` follows correctly from restricting the post-composition endomorphism `m_f^N` to V (giving `m_{R(g)(f)}^{N|_V}`). The proof is sufficient for formalization.
  - **Revised `def:presheaf_internal_hom` prose**: the explicit three-piece assembly description (a) value modules, (b) restriction maps semilinear over R(g), (c) functoriality via Over.map — is prover-ready without inference gaps. The `\uses{def:scheme_modules_tensorobj, def:presheaf_internal_hom_value, def:presheaf_internal_hom_slice_value, lem:presheaf_internal_hom_restriction}` is correct (acyclic once the restriction lemma's `\uses{}` is fixed).
  - **Informational**: `def:presheaf_internal_hom_value` lists `\uses{def:scheme_modules_tensorobj}`, which is not mathematically needed by `homModule` itself (the morphism module doesn't depend on the tensor product). Spurious but harmless — doesn't affect prover work.
  - **Informational**: `lem:presheaf_internal_hom_restriction`'s `\uses{}` is missing `def:presheaf_internal_hom_slice_value`, which the restriction map implicitly requires (it operates on morphisms of restricted presheaves, the object of that definition). Adding it would improve accuracy once the cycle is resolved.

### `blueprint/src/chapters/AbelianVarietyRigidity.tex` — complete + correct, no notes.

### `blueprint/src/chapters/AbelJacobi.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Jacobian.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Rigidity.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RigidityKbar.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Genus.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_StructureSheafAb.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_SheafCompose.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Cohomology_MayerVietoris.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - Zero `\uses{}` entries despite 57 decl blocks. Informational: dependency graph wiring absent, but all 57 blocks carry `\leanok` so the blueprint-leanok sync is grounded. No active prover; not gate-blocking.

### `blueprint/src/chapters/Albanese_CoheightBridge.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - Zero `\uses{}` entries. Informational: 4 decl blocks all `\leanok`, dependency wiring absent. Not gate-blocking; HELD lane.

### `blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex`
- **complete**: false
- **correct**: true
- **notes**:
  - Pointer-only file; 0 formal declaration blocks. Content is in `RigidityKbar.tex`. Not an unstarted phase (content exists elsewhere). No active prover; must-fix classification is informational for this stub — no writer dispatch needed until the pointer file's lane is de-gated.

### `blueprint/src/chapters/Differentials.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 5 decl blocks, 9 `\leanok`, but bare `REF` placeholders in live prose; cross-reference wiring incomplete. No active prover; Route C PAUSED. Writer dispatch deferred with HELD rationale acceptable.

### `blueprint/src/chapters/Picard_RelativeSpec.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - Zero `\uses{}` entries; 6 blocks all `\leanok`. Informational; no active prover.

### `blueprint/src/chapters/Picard_LineBundlePullback.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_RelPicFunctor.tex`
- **complete**: partial
- **correct**: partial
- **notes**:
  - Placeholder Lean bodies (`PicSharp := const PUnit`, `functorial := 0`) are explicitly dishonest per PROGRESS.md; proof sketches for these blocks are not formalization-ready. HELD (re-opens once TS lands `addCommGroup_via_tensorObj`). Per PROGRESS.md re-engagement gate: "replace dishonest placeholders first." No writer dispatch needed this iter; gate re-engages once Lane TS closes.

### `blueprint/src/chapters/Picard_FGAPicRepresentability.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 5 decl blocks, zero `\uses{}` wiring; 10 `sorry` annotations. HELD (gated A.2.c). Writer dispatch deferred with HELD rationale acceptable.

### `blueprint/src/chapters/Picard_QuotScheme.tex`
- **complete**: true
- **correct**: true
- **notes**:
  - 24 decl blocks; `\uses{}` internal chain present and acyclic. HELD (gated A.2.c). No gate-blocking finding.

### `blueprint/src/chapters/Picard_FlatteningStratification.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 10 decl blocks, 4 `\leanok`; 6 blocks without proof closure. HELD (gated A.2.c). Writer dispatch deferred with HELD rationale acceptable.

### `blueprint/src/chapters/Picard_IdentityComponent.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Picard_Pic0AbelianVariety.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` — complete + correct, no notes.

### `blueprint/src/chapters/RiemannRoch_OcOfD.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - REF placeholders in live prose. Route C PAUSED. Writer dispatch deferred with HELD rationale acceptable.

### `blueprint/src/chapters/RiemannRoch_OCofP.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 38 bare `REF` placeholders in live prose; cross-reference wiring incomplete. Route C PAUSED. Writer dispatch deferred with HELD rationale acceptable.

### `blueprint/src/chapters/RiemannRoch_RRFormula.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 38 bare `REF` placeholders in live prose. Route C PAUSED. Writer dispatch deferred with HELD rationale acceptable.

### `blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - Chapter-level `\uses{}` (outside any environment) references labels defined within the same file (`lem:morphism_to_p1_from_global_sections`, `lem:degree_via_pole_divisor`, `lem:degree_one_morphism_iso`) — this is a non-standard `\uses{}` placement and may or may not be parsed by the blueprint framework. Route C PAUSED (Lane RCI HELD). Writer dispatch deferred with HELD rationale acceptable.

### `blueprint/src/chapters/RiemannRoch_H1Vanishing.tex` — complete + correct, no notes.

### `blueprint/src/chapters/Albanese_AlbaneseUP.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - Zero `\uses{}` wiring; 6 decl blocks. HELD (gated A.2.c). Writer dispatch deferred with HELD rationale acceptable.

### `blueprint/src/chapters/Albanese_CodimOneExtension.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 18 decls, 9 `\leanok`; `\uses{}` references Kähler-module lemmas (`lem:module_free_kaehler_localization`, `lem:rank_kaehler_localization_eq_relative_dim`) with no apparent home chapter — potentially dangling. Route-1 EXCISED/HELD. Writer dispatch deferred with HELD rationale acceptable.

### `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 36 bare `REF` placeholders in live prose. Route-1 EXCISED/HELD. Writer dispatch deferred with HELD rationale acceptable.

### `blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex`
- **complete**: partial
- **correct**: true
- **notes**:
  - 2 decl blocks; thin proof content. Route-1 EXCISED/HELD. Writer dispatch deferred with HELD rationale acceptable.

---

## Cross-chapter notes

- `Picard_TensorObjSubstrate.tex` / `lem:presheaf_internal_hom_restriction` `\uses{}` creates a cycle with `def:presheaf_internal_hom` — the only active-lane cross-chapter integrity issue this iter.
- `Albanese_CodimOneExtension.tex` references Kähler-module lemmas with no home chapter; if this lane ever de-gates, a writer would need to identify where those lemmas live or create a new chapter for them.

---

## Severity summary

### must-fix-this-iter

1. **`Picard_TensorObjSubstrate.tex` / `lem:presheaf_internal_hom_restriction` `\uses{}` cycle (gate-blocking for Lane TS prover dispatch)**
   — Remove `def:presheaf_internal_hom` from the statement's `\uses{def:presheaf_internal_hom_value, def:presheaf_internal_hom}`; correct form is `\uses{def:presheaf_internal_hom_value}` (optionally also `def:presheaf_internal_hom_slice_value`). This is a one-line fix in the lemma statement. The proof body at line 2565 is already correct. Once fixed, the `\uses{}` DAG for `sec:tensorobj_dual_infra` is acyclic and mathematically accurate. Blueprint-writer or blueprint-clean subagent can apply the fix; re-dispatch me with a fresh scoped slug before the prover runs.

2. **HELD-lane partial chapters (action: writer dispatch or explicit HELD deferral note in iter-220/plan.md)** — The following chapters are `complete: partial` (content or wiring gaps) but in explicitly HELD/PAUSED/EXCISED lanes; the plan agent should record a one-line HELD deferral for each rather than dispatching a writer this iter:
   - `Picard_RelPicFunctor.tex` (also `correct: partial` — dishonest placeholders; re-engage gate defined in PROGRESS.md)
   - `Picard_FGAPicRepresentability.tex`, `Picard_FlatteningStratification.tex`, `Albanese_AlbaneseUP.tex` (gated A.2.c)
   - `Differentials.tex`, `RiemannRoch_OcOfD.tex`, `RiemannRoch_OCofP.tex`, `RiemannRoch_RRFormula.tex`, `RiemannRoch_RationalCurveIso.tex` (Route C PAUSED)
   - `Albanese_CodimOneExtension.tex`, `Albanese_AuslanderBuchsbaum.tex`, `Albanese_Thm32RationalMapExtension.tex` (Route-1 EXCISED/HELD)
   - `AlgebraicJacobian_Cotangent_GrpObj.tex` (stub pointer; content in `RigidityKbar.tex`)

### soon

- `lem:presheaf_internal_hom_restriction`'s `\uses{}` should also include `def:presheaf_internal_hom_slice_value` (the restriction map operates on the slice-specialized module objects); can be added in the same fix pass.
- `def:presheaf_internal_hom_value`'s `\uses{def:scheme_modules_tensorobj}` is spurious (`homModule` doesn't mathematically depend on `tensorObj`); low-priority cleanup.
- `Cohomology_MayerVietoris.tex`, `Albanese_CoheightBridge.tex`, `Picard_RelPicFunctor.tex` (once it re-engages), `Picard_RelativeSpec.tex`: zero `\uses{}` wiring despite upstream dependencies — blueprint dependency graph incompletely wired. Not gate-blocking for current prover lanes.

### informational

- `Cohomology_MayerVietoris.tex` / `Albanese_CoheightBridge.tex`: all blocks `\leanok`, content complete; the missing `\uses{}` wiring is the only gap and doesn't affect prover work.
- `RigidityKbar.tex` / `thm:rigidity_over_kbar`: marked `\leanok` in blueprint but proof body is a named sorry in Lean — this is the documented `[Field k]` gap, intentional and tracked in PROGRESS.md.

---

## Gate decision on `Picard_TensorObjSubstrate.tex` for Lane TS

**`complete: partial` / `correct: true` — GATE NOT CLEARED this iter.**

**Reason the gate fails:** the `\uses{}` cycle between `lem:presheaf_internal_hom_restriction` and `def:presheaf_internal_hom` is a structural error in the dependency graph; the directive's explicit acyclicity criterion is not satisfied.

**Reason it would not cause throwaway prover work:** the mathematical content of the three new blocks is correct and the decomposition is explicit enough that a prover would prove `restrictionMap` before `internalHom` regardless of the annotation. The gate failure is purely a blueprint graph integrity issue.

**Minimum fix path to clear the gate this iter:** dispatch a blueprint-clean (or writer) subagent to change line 2527:
```
  \uses{def:presheaf_internal_hom_value, def:presheaf_internal_hom}
```
to:
```
  \uses{def:presheaf_internal_hom_value, def:presheaf_internal_hom_slice_value}
```
(or just `\uses{def:presheaf_internal_hom_value}` if the slice-value edge is omitted). Then re-dispatch me with a fresh slug. If that scoped re-review clears, Lane TS prover can run this iter.

---

Overall verdict: `Picard_TensorObjSubstrate.tex` is mathematically correct for the three new `sec:tensorobj_dual_infra` blocks but carries a `\uses{}` cycle on `lem:presheaf_internal_hom_restriction` that prevents gate clearance; a one-line fix + scoped re-review can clear the gate within this iter. 13 held-lane chapters are `complete: partial` and require deferral notes in plan.md; 1 chapter (`Picard_RelPicFunctor`) is also `correct: partial` (dishonest Lean placeholder bodies). 0 unstarted-phase proposals.
