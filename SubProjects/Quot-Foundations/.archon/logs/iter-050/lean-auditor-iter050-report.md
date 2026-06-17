# Lean Audit Report

## Slug
iter050

## Iteration
050

## Scope
- files audited: 2
- files skipped (per directive): all others — directive explicitly scoped to two files

---

## Per-file checklist

### AlgebraicJacobian/Picard/FlatteningStratification.lean

- **outdated comments**: 3 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 0 (one intentional `sorry` — see notes)
- **bad practices**: 0
- **excuse-comments**: 0 genuine
- **notes**:
  - **New decls: all clean.**
    - `SheafOfModules.GeneratingSections.map` (line 2438): signature and body are genuine. `hF : PreservesColimitsOfSize.{u, u} F` is correctly taken as an explicit argument (not an instance); the comment at line 2435 explains why (def-backed `Scheme.Modules` functors do not synthesise reliably). The `preservesColimitsOfSize_shrink` universe-lowering and `epi_comp` composition are correct. No bad practice.
    - `map_I` (line 2453): `@[simp]` lemma, body is `rfl`, correct.
    - `map_isFiniteType` (line 2462): body `⟨inferInstanceAs (Finite σ.I)⟩` is correct — `map` preserves the index type definitionally, so `Finite σ.I` and `Finite (map σ F η hF).I` are the same instance.
    - `gf_localGenerators_restrict` (line 2489): no sorry, uses a four-step chain (overRestrictEquiv, overRestrictPullbackIso, pullback of homOfLE, pullbackComp+pullbackCongr). The `inferInstance` for `PreservesColimitsOfSize` on the equivalence functor is correct (equivalences preserve all (co)limits). The `leftAdjoint_preservesColimits` for `pullback j` is correct (left adjoints preserve colimits). Term-level `equivOfIso` steps look sound.
    - `gf_finiteType_affine_finite_cover_generated` (line 2525): no sorry. The **absent `[F.IsQuasicoherent]`** is genuinely unused: the theorem only produces `GeneratingSections` objects for pullbacks of `F` — it makes no claim about section-module finiteness or coherence. `IsQuasicoherent` would be needed when converting generating sections to module-finiteness (that step happens in the *separate* consumer `gf_finite_sections_of_basicOpen_finite_cover` which does carry `[F.IsQuasicoherent]`). No soundness hole.
  - **`genericFlatness` sorry (line 2577)**: intentional honest sorry. The proof sketch at lines 2628–2668 documents two precise missing Mathlib bridges: G1 (qcoh+finite-type ⟹ finite affine sections) and G3 (flatness local-on-source gluing). The comment correctly states "The witness V cannot be produced soundly until G1 is available." The sorry is honest and the documented gap is specific.
  - **Outdated-history comments (minor)**: multiple inline roadmap blocks reference internal iteration numbers ("iter-018", "iter-021", "iter-023" at lines 539–541, 655–682, 2603–2627). These are accurate descriptions of proof structure but carry project-internal workflow context (iteration numbers) that will decay in meaning over time. The iter-023 block (lines 2603–2627) is particularly long and inline; its mathematical content (counterexample for LocallyOfFiniteType without QuasiCompact) is accurate and the current signature matches, but it could be trimmed to a shorter note since the fix is already in the signature.
  - **`@[reducible] def pullbackModuleAddEquiv` (line 1358)**: `@[reducible]` on a `def` (not an `instance`) is acceptable here — it gates on explicit call sites and the body is a transport definition. No leaking instance risk.
  - **Raised heartbeat options**: multiple `set_option maxHeartbeats` / `set_option synthInstance.maxHeartbeats` with explanatory comments (e.g. lines 483–485, 1462–1465, 1700–1703, 1821–1824). These are engineering necessities for deeply nested localisation stacks, each is commented with the specific reason, and none is a silent suppression of an error.
  - **`globalUnitSection` proof (line 41–46 of GrassmannianQuot.lean — misplaced in note; this is in GrassmannianQuot)**: N/A here.

---

### AlgebraicJacobian/Picard/GrassmannianQuot.lean

- **outdated comments**: 0
- **suspect definitions**: 1 flagged (`Scheme.Modules.glue` — incomplete signature)
- **dead-end proofs**: 0 (all sorries are documented scaffolds, not dead ends)
- **bad practices**: 0
- **excuse-comments**: 1 flagged (`Scheme.Modules.glue` NOTE)
- **notes**:
  - **`globalUnitSection` (line 37)**: genuine, correct. The compatibility proof (`change` + `map_comp` + `congr 1`) is correct: `map f ∘ map (le_top Y)^op = map (le_top Z)^op` by functoriality; `congr 1` closes the morphism equality in the preorder category of opens.
  - **`scalarEnd` (line 50)**: genuine, uses `SheafOfModules.unit.unitHomEquiv`. Project-local but not a parallel API — Mathlib has no scalar-endomorphism-of-OX primitive. Clean.
  - **`chartQuotientMap` (line 64)**: axiom-clean. `haveI : HasFiniteBiproducts (SheafOfModules R) := HasFiniteBiproducts.of_hasFiniteProducts` is correct (finite products ⟹ finite biproducts in an Ab-enriched category). The `biproduct.matrix M` construction produces the matrix-of-scalars morphism correctly. The `biproduct.isoCoproduct` isos sandwich is the standard free-sheaf identification. No sorry.
  - **`Scheme.Modules.glue` (line 100)**: `sorry` body. Signature is structurally incomplete: the `_g` transition-data parameter lacks the multiplicative cocycle conditions (`g i j ≫ g j k = g i k` type conditions). The `_g` leading underscore marks it intentionally unused in the `sorry` body. The file-level NOTE (lines 87–90) explicitly says: *"the body and the module-cocycle hypotheses on `g` are still to be filled; the transition data `g` (per-overlap pullback isos) is recorded in the signature, the multiplicative cocycle conditions remain to be added before the construction is closed."* This satisfies the directive's requirement that the missing cocycle hypotheses be flagged in-file. However, this is a structural signature gap: if the body were ever filled without adding the cocycle conditions, the resulting construction would accept logically incoherent gluing data. **Must be fixed** (sorry + incomplete signature) before the scaffold can graduate to a real construction.
  - **`universalQuotient` (line 118)**: `sorry`, scaffold. NOTE says "rides on `Scheme.Modules.glue`; body to be filled once `glue` lands." Honest.
  - **`tautologicalQuotient` (line 126)**: `sorry`, scaffold. NOTE says same. Note that the return type mentions `universalQuotient d r` which is itself a sorry — the type is well-formed (it elaborates) but the object it refers to is degenerate. Honest scaffold.
  - **`functor` (line 138)**: `sorry`. NOTE documents the needed content (Setoid quotient + pullback functoriality). The return type `Scheme.{0}ᵒᵖ ⥤ Type` is correct for a moduli functor. Honest scaffold.
  - **`represents` (line 147)**: `sorry`. The return type `(functor d r).RepresentableBy (scheme d r)` is the correct type for the universal property statement. `RepresentableBy` is data (an equivalence of presheaves), correctly reflected as a `noncomputable def`. Since `functor d r := sorry`, the type partially degenerates, but this is accepted as scaffold state. Honest.
  - **Scaffold signatures not fake**: all five scaffold signatures (`glue`, `universalQuotient`, `tautologicalQuotient`, `functor`, `represents`) encode the correct mathematical content (the relevant types are genuine algebraic geometry types, not trivialised stand-ins). None is a parallel API reimplementing an existing Mathlib construction.

---

## Must-fix-this-iter

- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:100` — `Scheme.Modules.glue`: `sorry` body AND signature structurally incomplete (missing multiplicative cocycle conditions on `_g`). Why must-fix: the `_g` parameter is intentionally unused now, but any body filled without cocycle conditions would admit logically incoherent gluing data; blocks universalQuotient/tautologicalQuotient/functor/represents.
- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:118` — `universalQuotient`: `:= sorry`. Why must-fix: sorry on substantive construction, blocks tautologicalQuotient and the universal property.
- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:126` — `tautologicalQuotient`: `:= sorry`. Why must-fix: sorry on load-bearing morphism.
- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:138` — `functor`: `:= sorry`. Why must-fix: sorry on load-bearing moduli functor.
- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:147` — `represents`: `:= sorry`. Why must-fix: sorry on top-level universal property theorem.
- `AlgebraicJacobian/Picard/FlatteningStratification.lean:2577` — `genericFlatness`: `:= sorry`. Why must-fix: sorry on top-level geometric theorem; the two documented gaps (G1 and G3) are genuine Mathlib-absent pieces, not implementation shortcuts — honest and necessary but still blocking.

*Context note on the GrassmannianQuot sorries*: all five are explicitly self-documented scaffolds with accurate NOTEs describing what each needs. None is a hidden or misleading sorry. The must-fix classification reflects the audit rule (sorry on load-bearing claims), not hidden wrongness. The `Scheme.Modules.glue` sorry is additionally flagged because the signature has a structural hole (missing cocycle conditions), which makes it the most urgent.

*Context note on `genericFlatness`*: the proof roadmap in the file is detailed and accurate (two named gaps with specific Mathlib lemma identifications). The sorry is not premature — it correctly waits for G1 and G3.

---

## Major

- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:87-90` — `Scheme.Modules.glue` NOTE contains language of the form "conditions remain to be added before the construction is closed" — a mild excuse-comment acknowledging a signature gap. Reported here in addition to the must-fix for the sorry, because the incomplete-signature aspect warrants attention beyond the body sorry.

---

## Minor

- `AlgebraicJacobian/Picard/FlatteningStratification.lean:539–541, 655–682` — inline roadmap comment blocks referencing iteration numbers ("iter-018", "iter-021") inside proof bodies. These are accurate historical context (the proof was assembled in those iterations) but will decay in meaning as the project ages. Could be trimmed to structural descriptions without iteration numbers.
- `AlgebraicJacobian/Picard/FlatteningStratification.lean:2603–2627` — the `[QuasiCompact p]` justification block (iter-023) is verbose inline (25 lines including a counterexample). The fix is correct and the counterexample is valid, but the block's reference to iteration numbers makes it feel like a commit message embedded in source. The essential content ("the statement is false without QuasiCompact; see counterexample") could be kept in a shorter form.

---

## Excuse-comments (always called out separately)

- `AlgebraicJacobian/Picard/GrassmannianQuot.lean:87-90`: `"NOTE (scaffold): the body and the module-cocycle hypotheses on g are still to be filled; the transition data g (per-overlap pullback isos) is recorded in the signature, the multiplicative cocycle conditions remain to be added before the construction is closed."` (attached to `Scheme.Modules.glue`, which is a load-bearing construction for the entire GrassmannianQuot chain). Severity: **major** (documents a signature gap, not just a missing proof body). This is in-file acknowledgement of structural incompleteness, which is better than hiding it, but it still documents an incomplete state that must be resolved.

---

## Severity summary

- **must-fix-this-iter**: 6 — these block downstream work in their files until addressed (see above).
- **major**: 1
- **minor**: 2
- **excuse-comments**: 1 (also counted under major above; not critical because the NOTE honestly describes the gap rather than hiding it)

Overall verdict: FlatteningStratification is audit-clean on all new declarations, the dropped `[F.IsQuasicoherent]` is confirmed genuinely unused (not a soundness hole), and `genericFlatness` is an honest sorry with precisely documented remaining gaps; GrassmannianQuot has three axiom-clean declarations (`globalUnitSection`, `scalarEnd`, `chartQuotientMap`) and five explicitly-scaffolded sorries, with the `Scheme.Modules.glue` signature additionally carrying a structural gap (missing cocycle conditions) that is flagged in-file but must be corrected before the body is filled.
