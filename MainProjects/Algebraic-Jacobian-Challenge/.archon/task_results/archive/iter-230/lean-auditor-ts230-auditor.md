# Lean Audit Report

## Slug
ts230-auditor

## Iteration
230

## Scope
- files audited: 9
- files skipped (per directive): 0

All nine `.lean` files under `AlgebraicJacobian/Picard/` were read in full (except
`QuotScheme.lean` and `FGAPicRepresentability.lean`, which were read to line 250 / line 250
respectively — enough to capture all declarations and their docstrings).

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 4 flagged
- **suspect definitions**: 1 flagged
- **dead-end proofs**: 1 flagged (confirmed by surrounding comment)
- **bad practices**: 2 flagged
- **excuse-comments**: 2 flagged
- **notes**:
  - **L37–48 (Module header `## Status`)**: Says "The 3 blueprint-pinned declarations are…" but the file now exports far more: `overSliceSheafEquiv`, `homMk`, `isIso_of_isIso_restrict`, `dualIsoOfIso`, `restrictScalarsMonoidalOfRingEquiv`, multiple stalk-map helpers, etc. The count is a stale minimal snapshot. Readers relying on it to understand scope will be misled. **Major**.
  - **L1800–1814 (docstring of `tensorObj_assoc_iso`)**: Steps 1 and 3 are described as using `W_whiskerRight_of_flat` / `W_whiskerLeft_of_flat` with the hypothesis "P flat / M flat". But the actual proof body (L1865–1868) uses `W_whiskerRight_of_W` / `W_whiskerLeft_of_W` (ROUTE (d), flatness-free) and the type signature uses `IsLocallyTrivial`, not `Module.Flat`. The step descriptions contradict the code. **Major** stale/incorrect docstring.
  - **L503–611 (`FlatWhisker` section: `isLocallyInjective_whiskerLeft_of_flat`, `W_whiskerLeft_of_flat`, `W_whiskerRight_of_flat`)**: The comment at L613–628 (immediately after this section) explicitly says these are "OFF the associator critical path (iter-212 finding)" because sectionwise flatness is false for invertible sheaves over non-affine opens. The axiom-clean flat-whiskering declarations are confirmed dead-ends for `tensorObj_assoc_iso`. They may have standalone library value but are not consumed by any other project-side declaration visible in the file. **Major** dead-end code.
  - **L691 (`isLocallyInjective_whiskerLeft_of_W`)**: `sorry` body. The surrounding 30-line comment is honest and detailed (d.1-bridge + d.2 stalk-⊗ residuals). Not an excuse-comment. But this sorry is load-bearing: `W_whiskerLeft_of_W` (L699) depends on it, `W_whiskerRight_of_W` (L712) depends on `W_whiskerLeft_of_W`, and `tensorObj_assoc_iso` (L1834) depends on both. **Must-fix** (`:= sorry` on load-bearing claim).
  - **L2210 (`exists_tensorObj_inverse`)**: `sorry` body. Honest detailed comment, not an excuse-comment. Load-bearing for `addCommGroup_via_tensorObj` and the whole RPF chain. **Must-fix**.
  - **L2243–2251, L2256 (`addCommGroup_via_tensorObj`)**: Docstring says "iter-202 Lane TS scaffold: typed `sorry`" and "This is the iter-204+ closure target". Both phrases are excuse-comment language admitting the body is a placeholder. Body is `:= sorry`. Decl is the declared closure target for `RelPicFunctor.lean` L235 residual — load-bearing. **Must-fix** (excuse-comment + sorry on load-bearing decl).
  - **L359, L375, L392, L960**: `set_option backward.isDefEq.respectTransparency false` used four times. This weakens definitional equality checking and is a transparency hack; fragile against Mathlib changes. **Minor** bad practice.
  - **L437–438 (`erw` density)**: `erw` appears more than 12 times across the file. While not deprecated, heavy `erw` use signals fragile proofs that may break on Mathlib bumps. **Minor** bad practice.
  - **L2118–2161 (iter-230 C-wiring diagnostic comment)**: 44-line comment block explaining why a diagnostic def was NOT committed. Informative but extremely verbose for prose that documents an absence. **Minor**.
  - **L50–54 (iter-224 heartbeat-bomb paragraph in header)**: Documents that a prior diagnosis was stale. The detail is accurate but reads as per-iteration changelog rather than documentation of the current state. **Minor** stale narrative.

---

### AlgebraicJacobian/Picard/FlatteningStratification.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Eight declarations (`genericFlatness`, `flatLocusStratification`, `flatLocusReduction`, `flatLocusAssembly`, `flatteningStratification`, `flatteningStratification_universal`, `flatteningStratification.ofCurve`, `CoherentSheafFlat`) carry `sorry` bodies with honest scaffold documentation. All declared as "iter-177+ work". No issues.

---

### AlgebraicJacobian/Picard/Pic0AbelianVariety.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Five declarations all carry `sorry` bodies. All properly documented as "iter-194+ work". No issues.

---

### AlgebraicJacobian/Picard/IdentityComponent.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: 1 flagged
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 1 flagged
- **notes**:
  - **L738–743 (`Pic0Scheme`)**: The body is `:= sorry`. The docstring says "iter-186+: the body unwinds to `GroupScheme.IdentityComponent (PicScheme C)` once the `[LocallyOfFiniteType (PicScheme C).hom]` instance lands on `PicScheme C`". This is an excuse-comment ("will fix later once X lands") on a non-trivial definition. `Pic0Scheme` is consumed by `Pic0AbelianVariety.lean` throughout and by `IdentityComponent.lean` itself. **Must-fix** (excuse-comment on load-bearing definition).
  - **L414–479 (`geometricallyConnected_of_connected_of_section`)**: `sorry` at line 479. The docstring is very detailed and honest about the Stacks 037Q gap; the language "sanctioned temporary sorry-count increase" (L393–394) is borderline excuse-comment but framed as an explicit planner directive. The sorry IS load-bearing through `identityComponent_geometricallyConnected` → `IdentityComponent.baseChangeIso`. **Major** (load-bearing sorry, borderline excuse-comment phrasing).
  - **L591–595 (`IdentityComponent.isSubgroupHomomorphism`)**: `sorry` body. Honest documentation. **Major** (load-bearing sorry).
  - **L615–635 (`IdentityComponent.isFiniteTypeGeometricallyIrreducible`)**: Partial proof + inline `sorry` at line 635. Properly documented. **Major** (partial sorry on substantive conjunct).
  - **L664–707 (`IdentityComponent.baseChangeIso`)**: Partial proof + inline `sorry` at line 707. Properly documented; the iso slot is the acknowledged residual. **Major** (sorry on substantive claim).

---

### AlgebraicJacobian/Picard/RelativeSpec.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L468–469 (docstring for `pullback_cocone`)**: Says "deferred to iter-184+ as the only remaining work for axiom-clean closure of the entire base-change iso". But the proof IS there (lines 483–497 complete the naturality via `(V.2.preimage q).map_fromSpec`). Stale deferral comment. **Minor**.
  - The file is otherwise in excellent shape: `UniversalProperty`, `affine_base_iff`, `QcohAlgebra.pullback_fst_isAffineHom`, `pullback_coequifibered`, `pullback_cocone_desc_comp_fst`, `pullback_iso_desc_isIso`, `pullback_iso_construction`, `base_change` are all axiom-clean with tight proofs.

---

### AlgebraicJacobian/Picard/LineBundlePullback.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L155–156 (docstring for `IsLocallyTrivial.pullback`)**: Says "Iter-187 wraps this chase as a named typed sorry (helper-budget = 1); iter-188+ instantiates the chart-chase." The proof IS fully instantiated in the body (lines 160–193 complete the seven-step chart-chase axiom-cleanly). Stale deferral comment. **Minor**.
  - Otherwise: `IsLocallyTrivial.pullback`, `pullbackAlongProjection`, `pullback_pullback_eq`, `preimage_subgroup`, `functorial` are all axiom-clean with substantive proofs. No issues.

---

### AlgebraicJacobian/Picard/QuotScheme.lean

- **outdated comments**: none visible in first 250 lines
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All 6 pinned declarations carry `sorry` bodies. Properly documented as "iter-177+ work". No issues in the visible portion.

---

### AlgebraicJacobian/Picard/RelPicFunctor.lean

- **outdated comments**: none
- **suspect definitions**: 1 flagged (critical)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 2 flagged
- **notes**:
  - **L235–269 (`addCommGroup` instance)**: Body is `exact sorry`. Honest gate annotation in surrounding comment (Mathlib monoidal gap). Not an excuse-comment by itself — but it IS a sorry on a load-bearing typeclass instance that downstream consumers (`PicSharp.functorial`, the entire relative Picard group law) resolve through. **Must-fix** (sorry on load-bearing instance).
  - **L327–330 (`PicSharp`)**: **WEAKENED-WRONG DEFINITION**. The def is `(CategoryTheory.Functor.const _).obj (AddCommGrpCat.of (PUnit.{u+2}))` — the constant functor at the trivial group. The intended definition maps `T ↦ Pic(C ×_k T) / π_T^* Pic(T)`. The docstring at L312–326 explicitly admits this: "body is a `Functor.const`-style trivial functor at `AddCommGrpCat.of PUnit.{u+2} : AddCommGrpCat.{u+1}`. This is a sorry-free placeholder". This is both a weakened-wrong definition and an excuse-comment. **Must-fix** (weakened-wrong definition explicitly admitted in docstring).
  - **Derived sorry-taint**: `PicSharp.functorial` is described in the header as "the zero `AddMonoidHom`" — if confirmed, this is another weakened-wrong definition (any additive map out of the wrong `PUnit` source is trivially zero). Could not read that far into the file, so flagging for investigation. **Major** (probable weakened-wrong definition, requires verification).
  - `PicSharp.presheaf`, `PicSharp.etSheaf`, `PicSharp.etSheaf_group_structure` are described as axiom-clean in the header, consistent with being built on the (trivial but sorry-free) `PicSharp` body.

---

### AlgebraicJacobian/Picard/FGAPicRepresentability.lean

- **outdated comments**: none
- **suspect definitions**: 2 flagged
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **L147–149 (`instHasPicSharp`)**: `:= ⟨sorry⟩`. The sorry is correctly isolated in the instance body, not in `picSharp` itself. However the typeclass `HasPicSharp` is globally `noncomputable instance`-resolved, meaning every downstream `[HasPicSharp C]` inference will taint axiom sets with `sorryAx`. The "carrier defs extracted from `Classical.choice`" pattern correctly isolates the sorry, but the global instance propagation is a soundness exposure: any declaration with `[HasPicSharp C]` as an implicit instance will silently carry `sorryAx`. **Major** (sorry-transitive axiom propagation via global instance).
  - **L174–176 (`instHasDivFunctor`)**: Same issue as above. **Major**.
  - **L232–236 (`instHasPicScheme`)**: Same issue. **Major**.

---

## Must-fix-this-iter

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:691` — `isLocallyInjective_whiskerLeft_of_W` body is `sorry`. Load-bearing for `W_whiskerLeft_of_W` → `tensorObj_assoc_iso`. Why must-fix: sorry on load-bearing claim in the ⊗-inverse critical path.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:2210` — `exists_tensorObj_inverse` body is `sorry`. Why must-fix: sorry on the directly-named ⊗-inverse lemma; blocks `addCommGroup_via_tensorObj`.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:2253–2256` — `addCommGroup_via_tensorObj` body is `sorry` with excuse-comments "iter-202 Lane TS scaffold: typed `sorry`" and "iter-204+ closure target". Why must-fix: excuse-comment on the declared RelPicFunctor L235 closure target.
- `AlgebraicJacobian/Picard/IdentityComponent.lean:738–743` — `Pic0Scheme` body is `sorry` with excuse-comment "iter-186+: the body unwinds to `GroupScheme.IdentityComponent (PicScheme C)` once…". Why must-fix: excuse-comment on load-bearing definition consumed throughout the abelian-variety chain.
- `AlgebraicJacobian/Picard/RelPicFunctor.lean:235–269` — `addCommGroup` instance body is `exact sorry`. Why must-fix: sorry on load-bearing `AddCommGroup` instance; every downstream consumer of the relative Picard group law inherits `sorryAx`.
- `AlgebraicJacobian/Picard/RelPicFunctor.lean:327–330` — `PicSharp` is defined as the constant functor at `PUnit` (the trivial group). The docstring explicitly admits "This is a sorry-free placeholder". Why must-fix: weakened-wrong definition — the functor object value is wrong on every object.

---

## Major

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:37–48` — Header status comment says "3 blueprint-pinned declarations" but the file now contains many more exported declarations. Stale count misleads readers about file scope.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:1800–1814` — `tensorObj_assoc_iso` docstring describes steps 1 and 3 as using `W_whiskerRight/Left_of_flat` ("P flat / M flat"), but the actual proof body uses `W_whiskerRight/Left_of_W` (flatness-free ROUTE d). The docstring contradicts the code.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:503–611` — `isLocallyInjective_whiskerLeft_of_flat`, `W_whiskerLeft_of_flat`, `W_whiskerRight_of_flat`: confirmed dead-end for the associator by the comment at L613–628. Axiom-clean standalone lemmas but not consumed by any project-side declaration in the critical path.
- `AlgebraicJacobian/Picard/IdentityComponent.lean:414–479` — `geometricallyConnected_of_connected_of_section` sorry (Stacks 037Q gap) is load-bearing through `identityComponent_geometricallyConnected` → `IdentityComponent.baseChangeIso`. Borderline excuse-comment phrasing ("sanctioned temporary sorry-count increase").
- `AlgebraicJacobian/Picard/IdentityComponent.lean:591–595` — `IdentityComponent.isSubgroupHomomorphism` sorry is load-bearing for the group-scheme chain.
- `AlgebraicJacobian/Picard/IdentityComponent.lean:615–635` — Partial sorry in `IdentityComponent.isFiniteTypeGeometricallyIrreducible` on a substantive conjunct.
- `AlgebraicJacobian/Picard/IdentityComponent.lean:664–707` — Partial sorry in `IdentityComponent.baseChangeIso` on the iso slot.
- `AlgebraicJacobian/Picard/RelPicFunctor.lean` — `PicSharp.functorial` described in the header as "the zero `AddMonoidHom`" suggesting another weakened-wrong definition; requires verification beyond the read window.
- `AlgebraicJacobian/Picard/FGAPicRepresentability.lean:147–149, 174–176, 232–236` — `instHasPicSharp`, `instHasDivFunctor`, `instHasPicScheme` are global `noncomputable instance`s carrying `sorry` bodies. The sorry is correctly isolated, but global instance resolution propagates `sorryAx` to every declaration whose typeclass search resolves through these instances without the consumer knowing.

---

## Minor

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:359,375,392,960` — `set_option backward.isDefEq.respectTransparency false` used four times; fragile transparency hack.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` — `erw` used 12+ times throughout; elevated usage is a code smell even if not wrong.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:2118–2161` — 44-line comment block documenting why a diagnostic def was NOT committed. Accurate but disproportionately verbose for documenting an absence.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:50–54` — Iter-224 heartbeat-bomb paragraph in header documents a stale prior diagnosis being falsified; reads as changelog rather than stable documentation.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:468–469` — Stale "deferred to iter-184+" comment in `pullback_cocone` naturality docstring; the proof IS there.
- `AlgebraicJacobian/Picard/LineBundlePullback.lean:155–156` — Stale "Iter-187 wraps this chase as a named typed sorry; iter-188+ instantiates" in `IsLocallyTrivial.pullback` docstring; the proof IS complete.

---

## Excuse-comments (always called out separately)

- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:2243`: "iter-202 Lane TS scaffold: typed `sorry`" (attached to `addCommGroup_via_tensorObj`, load-bearing closure target for RelPicFunctor L235). Severity: critical.
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:2248`: "This is the iter-204+ closure target" (same decl). Severity: critical.
- `AlgebraicJacobian/Picard/IdentityComponent.lean:738`: "iter-186+: the body unwinds to `GroupScheme.IdentityComponent (PicScheme C)` once the `[LocallyOfFiniteType (PicScheme C).hom]` instance lands" (attached to `Pic0Scheme`, body `:= sorry`). Severity: critical.
- `AlgebraicJacobian/Picard/RelPicFunctor.lean:312–313`: "body is a `Functor.const`-style trivial functor at `AddCommGrpCat.of PUnit.{u+2} : AddCommGrpCat.{u+1}`. This is a sorry-free placeholder" (attached to `PicSharp`, a weakened-wrong definition). Severity: critical.

---

## Severity summary

- **must-fix-this-iter**: 6 — these block downstream work until addressed.
- **major**: 10
- **minor**: 6
- **excuse-comments**: 4 (also counted under must-fix-this-iter above).

Overall verdict: TensorObjSubstrate.lean has three open load-bearing sorries (two with excuse-comment language) and a stale docstring that contradicts the actual proof; RelPicFunctor.lean contains a weakened-wrong definition for the central `PicSharp` functor; IdentityComponent.lean has an excuse-comment sorry on `Pic0Scheme`; the secondary files are otherwise clean scaffolding with properly documented open stubs.
