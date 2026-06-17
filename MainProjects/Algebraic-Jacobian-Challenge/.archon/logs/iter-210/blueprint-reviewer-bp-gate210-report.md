# Blueprint Review Report

## Slug
bp-gate210

## Iteration
210

---

## Top-level summaries

### Proofs lacking detail

- `Picard_TensorObjSubstrate.tex` / `lem:tensorobj_isoclass_commgroup`: the proof text discharges associativity by invoking `lem:tensorobj_assoc_iso`, but that lemma is scoped to **invertible** objects only. For the CommMonoid on **all** iso-classes (as the lemma claims), associativity for non-invertible M, N, P is unproved. The actual need (and the strategy's description) is a **CommGroup on invertible iso-classes**. The lemma statement must be rescoped. See the Hard Gate section.

- `Picard_TensorObjSubstrate.tex` / internal-consistency check (line 1283): stale prose says the associator "additionally needs the sheafification–tensor absorption iso." The actual proof block and LOC-estimate section both confirm the iter-210 re-scoping eliminated the absorption iso requirement. The internal-consistency note was not updated.

- `AbelianVarietyRigidity.tex` / `lem:rigidity_eqOn_dense_open` and `lem:rigidity_eqAt_closedPoint_of_proper_into_affine` proof blocks: both retain "single genuinely-deep residual sorry" wording superseded by a `% NOTE (iter-162 review)` annotation flagging the chain as fully closed axiom-clean. The prose should be updated to reflect iter-162 completion (cosmetic; does not affect mathematical correctness or the Lean content).

### Lean difficulty quality

- `Albanese_Thm32RationalMapExtension.tex`: the agent audit flagged the main theorem (`thm:rational_map_to_av_extends`) as missing a `\lean{...}` hint inside that chapter file. Note: `lem:rational_map_to_av_extends` IS pinned in `AbelianVarietyRigidity.tex` with `\lean{AlgebraicGeometry.rationalMap_to_av_extends}`; cross-check whether `Albanese_Thm32RationalMapExtension.tex` contains a duplicate or forward-pointer pin, or whether the hint is genuinely absent from that chapter.

- `Picard_RelPicFunctor.tex` / `thm:rel_pic_etale_sheaf_unit_canonical`: no `\lean{...}` pin — intentional forward-looking block; prover cannot be dispatched on this block until the upstream `Scheme.Modules` monoidal-structure gap is closed. (Documented and acceptable as-is.)

---

## Hard Gate: `Picard_TensorObjSubstrate.tex`

**Active prover lane: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (A.1.c.SubT)**

### Gate checklist (directive items)

**1. Four coherence isos stated as objectwise existence-of-iso lemmas the group law consumes?**

| Lemma | Scope | Consumes | Verdict |
|---|---|---|---|
| `lem:tensorobj_assoc_iso` | M, N, P ⊗-invertible | `lem:tensorobj_isoclass_commgroup` | ✓ |
| `lem:tensorobj_unit_iso` | M arbitrary | `lem:tensorobj_isoclass_commgroup` | ✓ |
| `lem:tensorobj_comm_iso` | M, N arbitrary | `lem:tensorobj_isoclass_commgroup` | ✓ |
| inverse | carried by `def:scheme_modules_isinvertible` (existential predicate) | units characterization in `lem:tensorobj_isoclass_commgroup` | ✓ |

Each is an objectwise existence-of-isomorphism statement (not a natural transformation, no pentagon/triangle/hexagon). The group law consumes them only as propositions `Nonempty(... ≅ ...)`. **CONFIRMED.**

**2. No block still claims an arbitrary-module associator?**

- `lem:tensorobj_assoc_iso` (lines 531–593): "Let M, N, P be ⊗-invertible… There is an isomorphism." The proof uses local-trivialization on a common affine cover where all three trivialise, applies `Module.TensorProduct.assoc` on each affine, and glues. The proof block explicitly states: "uses no MonoidalClosed(PresheafOfModules R), no sheafification–tensor absorption isomorphism, and no open-immersion restriction-compatibility." The old MonoidalClosed / absorption-iso `% NOTE` was removed per iter-210 re-scoping. **CONFIRMED — no arbitrary-module associator remains on the critical path.**

**3. Group-law assembly coherent with the invertible-scoped isos?**

Here I have a **must-fix finding**. The lemma `lem:tensorobj_isoclass_commgroup` states:

> "The isomorphism classes of **objects** of Scheme.Modules X… form a commutative monoid… associativity, unitality and commutativity are the coherence isomorphisms lem:tensorobj_assoc_iso, lem:tensorobj_unit_iso and lem:tensorobj_comm_iso."

But `lem:tensorobj_assoc_iso` is scoped to **⊗-invertible** objects only. For the CommMonoid on ALL iso-classes, associativity must hold for non-invertible M, N, P — which is not proved and would require the full monoidal-category structure that the chapter explicitly avoids (`rem:scheme_modules_monoidal_off_path`).

**The strategy describes the correct target:** "The Picard group is Units of the commutative monoid of ⊗-iso-classes of **invertible objects** of Scheme.Modules." The assembly proves **exactly that**: a CommGroup on invertible iso-classes, with associativity for invertible M, N, P. The lemma statement over-claims by saying ALL iso-classes form a CommMonoid.

**Directed fix**: Rescope `lem:tensorobj_isoclass_commgroup` to "The isomorphism classes of ⊗-invertible objects of Scheme.Modules X form a commutative group under ⊗" (i.e., a CommGroup, not a CommMonoid on all iso-classes). The Lean declaration `tensorObjIsoclassCommMonoid` should target the CommGroup on invertible iso-classes directly. The rest of the assembly (`thm:rel_pic_addcommgroup_via_tensorobj`) is unaffected — it only consumes the units group.

The mathematical content NEEDED BY THE PROVER (CommGroup on invertible iso-classes) is correctly assembled. The issue is the prose statement, which if taken literally would require the prover to prove associativity for all modules — an impossible task without the full monoidal structure.

**4. Proof sketches detailed enough for a prover?**

Yes. The three-piece decomposition (Piece 1: definition + functoriality; Piece 2: IsInvertible predicate + three coherence isos + LOC estimates; Piece 3: lift to OnProduct + consumer instance) provides a clear implementation roadmap with explicit Mathlib API names, LOC estimates, and sequencing constraints. The local-trivialization proof sketch for `lem:tensorobj_assoc_iso` is detailed: pick common affine cover, apply `Module.TensorProduct.assoc` on each Uᵢ, check overlaps via transition data in `O_X^×`, glue. **CONFIRMED.**

### Gate verdict

- **complete: true** — all required declarations are present with adequate prose.
- **correct: partial** — `lem:tensorobj_isoclass_commgroup` over-states: the prose claims a CommMonoid on all iso-classes, but the assembly only proves associativity for invertible objects (sufficient for the actual CommGroup-on-invertible-iso-classes goal). This is a must-fix before the prover dispatches.
- **Must-fix before prover dispatch**: Rescope `lem:tensorobj_isoclass_commgroup` statement to CommGroup on invertible iso-classes. Also update the stale internal-consistency note (line 1283) about the absorption iso.

**The prover MAY proceed on `TensorObjSubstrate.lean` if directed to implement `tensorObjIsoclassCommMonoid` as a CommGroup on invertible iso-classes, not a CommMonoid on all iso-classes. The fast-path same-iter option applies: once a blueprint-writer corrects the `lem:tensorobj_isoclass_commgroup` statement, a scoped re-review (TensorObjSubstrate only) will clear the gate.**

---

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex — complete + correct, no notes.

### blueprint/src/chapters/AbelianVarietyRigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:rigidity_eqOn_dense_open` and `lem:rigidity_eqAt_closedPoint_of_proper_into_affine` proof blocks: "single genuinely-deep residual sorry" wording is stale — `% NOTE (iter-162 review)` confirms chain closed axiom-clean. Blueprint-writer should update prose to "chain closed iter-162" in both blocks (cosmetic; `\leanok` markers are correct). Soon severity.

### blueprint/src/chapters/Albanese_AlbaneseUP.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `lem:symmetric_product_to_jacobian` birationality proof invokes Riemann–Roch at deg D = g (for generic-fibre identification). This is gated on Route C (PAUSED). The `% NOTE (iter-199)` correctly flags this gate. Chapter is not in an active prover lane (gated on A.2.c), so no current prover blocker.

### blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CoheightBridge.tex — complete + correct, no notes.

### blueprint/src/chapters/Albanese_CodimOneExtension.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Agent audit: several definitions have `\leanok` but missing `\lean{...}` hints. This is a Route-1 cone chapter (retained reversibly behind deletion gate); not on A.1.c.SubT critical path. Soon severity.

### blueprint/src/chapters/Albanese_Thm32RationalMapExtension.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Agent flagged possible missing `\lean{...}` hint on `thm:rational_map_to_av_extends` within this file (the hint exists in `AbelianVarietyRigidity.tex` but may be absent here). Plan agent should verify cross-file hint coverage. Soon severity.

### blueprint/src/chapters/AlgebraicJacobian_Cotangent_GrpObj.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Stub/pointer chapter: no `\leanok` markers, no `\lean{...}` hints. Content is documented as living in `RigidityKbar.tex` (fallback route (a), off critical path). Must-fix applies strictly per audit rules; plan agent may record explicit deferral rationale.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_SheafCompose.tex — complete + correct, no notes.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Agent: some declarations missing `\lean{...}` hints. Not on A.1.c.SubT critical path. Soon severity.

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Agent: mixed `\leanok` status; some declarations not yet closed. Infrastructure chapter consumed by RiemannRoch chain (Route C, PAUSED). Soon severity.

### blueprint/src/chapters/Differentials.tex
- **complete**: partial
- **correct**: true
- **notes**:
  - Agent: some declarations `\leanok`, some not; `thm:smooth_locally_free_omega` not fully closed. Used by RigidityKbar fallback route (a), off A.1.c.SubT critical path. Soon severity.

### blueprint/src/chapters/Genus.tex — complete + correct, no notes.

### blueprint/src/chapters/Genus0BaseObjects_Cross01Substrate.tex — complete + correct, no notes.

### blueprint/src/chapters/Jacobian.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FGAPicRepresentability.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_FlatteningStratification.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_IdentityComponent.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_LineBundlePullback.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_Pic0AbelianVariety.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_QuotScheme.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelativeSpec.tex — complete + correct, no notes.

### blueprint/src/chapters/Picard_RelPicFunctor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All six declaration bodies are `\leanok` but carry documented `% NOTE` comments that the Lean bodies are placeholder (constant-PUnit functor) pending the tensor-substrate gap this iteration closes. Once `TensorObjSubstrate.lean` closes, these five sorries collapse to one per the chapter's Gate Annotation section. This is the expected pre-A.1.c.SubT state.
  - `thm:rel_pic_etale_sheaf_unit_canonical`: no `\lean{...}` pin — intentional forward-looking; acceptable.

### blueprint/src/chapters/Picard_TensorObjSubstrate.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - **MUST-FIX (see Hard Gate section):** `lem:tensorobj_isoclass_commgroup` statement claims CommMonoid on ALL iso-classes, but `lem:tensorobj_assoc_iso` (the only associativity witness) is restricted to ⊗-invertible objects. Correct target is CommGroup on invertible iso-classes. Prover must target the CommGroup directly.
  - **SOON:** Internal-consistency check (line 1283) contains stale prose: "The associator additionally needs the sheafification–tensor absorption iso." The absorption iso was eliminated by the iter-210 re-scoping to invertible objects; this note conflicts with the proof block at lines 590–593 and the LOC section at lines 1157–1163.

### blueprint/src/chapters/RiemannRoch_H1Vanishing.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OCofP.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_OcOfD.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RRFormula.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_RationalCurveIso.tex — complete + correct, no notes.

### blueprint/src/chapters/RiemannRoch_WeilDivisor.tex — complete + correct, no notes.

### blueprint/src/chapters/Rigidity.tex — complete + correct, no notes.

### blueprint/src/chapters/RigidityKbar.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:rigidity_over_kbar` is a named gap (sorry body, iter-155 disposition). Chapter explicitly documents this and the two gated routes (a)/(b). The committed genus-0 route is in `AbelianVarietyRigidity.tex`; this chapter is fallback route (a), retained reversibly. State is coherent with strategy.

---

## Cross-chapter notes

- `Picard_TensorObjSubstrate.tex` / `lem:tensorobj_isoclass_commgroup` and `Picard_RelPicFunctor.tex` / `lem:rel_pic_sharp_groupoid`: the consumer (`lem:rel_pic_sharp_groupoid`) gates on `thm:rel_pic_addcommgroup_via_tensorobj` which in turn gates on `lem:tensorobj_isoclass_commgroup`. The must-fix to `lem:tensorobj_isoclass_commgroup`'s statement flows through to the consumer; the consumer is correctly stated (AddCommGroup on the Picard quotient) and will remain correct once the upstream lemma is properly scoped.

---

## Severity summary

### Must-fix-this-iter

1. **`Picard_TensorObjSubstrate.tex` / `lem:tensorobj_isoclass_commgroup` (blueprint statement mismatch):** Statement claims CommMonoid on all iso-classes; assembly only proves associativity for invertible objects (sufficient for CommGroup on invertible iso-classes, which is the actual target). Dispatch a blueprint-writer to rescope the lemma statement before the prover closes Piece 2. Same-iter fast path: after writer correction, re-review TensorObjSubstrate only to clear the gate.

2. **`AlgebraicJacobian_Cotangent_GrpObj.tex` (stub chapter, no `\leanok`):** Applies strictly by audit rules. Plan agent should record explicit deferral rationale: "chapter covers fallback route (a) cotangent/GrpObj content, off committed critical path; no prover dispatch pending."

3. **`Albanese_CodimOneExtension.tex`, `Albanese_Thm32RationalMapExtension.tex`, `Cohomology_StructureSheafAb.tex`, `Cohomology_StructureSheafModuleK.tex`, `Differentials.tex` (partial status):** All are off the A.1.c.SubT active lane and gated by unavailable infrastructure (A.2.c, Route C). Plan agent should record deferral rationale for each. The strict rule fires; the remedy is the rationale record, not immediate writer dispatch.

### Soon

- `Picard_TensorObjSubstrate.tex` / internal-consistency check line 1283: stale "absorption iso" note.
- `AbelianVarietyRigidity.tex` / `lem:rigidity_eqOn_dense_open` and `lem:rigidity_eqAt_closedPoint_of_proper_into_affine` proof blocks: "single genuinely-deep residual sorry" wording superseded by iter-162 completion; update to "chain closed iter-162."
- `Albanese_Thm32RationalMapExtension.tex`: verify `\lean{...}` hint coverage for `thm:rational_map_to_av_extends` within that file.

Overall verdict: **Hard Gate CONDITIONALLY CLEARS for A.1.c.SubT** — `lem:tensorobj_isoclass_commgroup` statement must be rescoped to CommGroup on invertible iso-classes before prover dispatch (same-iter writer + scoped re-review fast path). All other chapters: 0 phases have zero blueprint coverage; the 5 partial chapters are all gated by unavailable infrastructure (Route C / A.2.c) and carry deferral rationale rather than active prover work.
