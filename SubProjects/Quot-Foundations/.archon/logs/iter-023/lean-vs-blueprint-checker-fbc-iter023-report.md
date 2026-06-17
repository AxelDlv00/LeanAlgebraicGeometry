# Lean ↔ Blueprint Check Report

## Slug
fbc-iter023

## Iteration
023

## Files audited
- Lean: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- Blueprint: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex`

## Focus
gstar-chain decomposition (effort-breaker `fbc-gstar`): three new theorems (`gstar_counit_transport`, `gstar_generator_close`, `inner_value_eq`) plus two intermediate blueprint blocks (`inner_unitReduce`, `inner_eCancel`) and three private helper lemmas.

---

## Per-declaration

### `\lean{AlgebraicGeometry.base_change_mate_inner_unitReduce}` (chapter: `lem:base_change_mate_inner_unitReduce`)
- **Lean target exists**: **no** — no declaration named `base_change_mate_inner_unitReduce` anywhere in the file. Closest: the prose content is partially captured by the partial proof of `base_change_mate_inner_value_eq` (line 1570), but no standalone declaration exists.
- **Signature matches**: N/A — nothing to compare.
- **Proof follows sketch**: N/A.
- **notes**: Blueprint block (line ~1997) has `\lean{AlgebraicGeometry.base_change_mate_inner_unitReduce}` and `\uses{...}` but **no `\leanok`** and **no `% LEAN SIGNATURE` hint**. The block describes a four-factor Γ-image distribution whose exact Lean type (intermediate objects after each factor, `letI` algebra instances, source/target types) is not pinned anywhere in the chapter. The prover deferred this as impossible to safely stub from prose alone. See blueprint adequacy section.

### `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel}` (chapter: `lem:base_change_mate_inner_eCancel`)
- **Lean target exists**: **no** — no declaration named `base_change_mate_inner_eCancel` anywhere in the file.
- **Signature matches**: N/A.
- **Proof follows sketch**: N/A.
- **notes**: Blueprint block (line ~2053) has `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel}` and `\uses{...}` but **no `\leanok`** and **no `% LEAN SIGNATURE` hint**. The codomain type after the three-factor cancellation depends on knowing the exact `letI` stack and intermediate object names from `inner_unitReduce`'s output, which are not pinned. Same prover assessment as `inner_unitReduce`: not safe to stub without a concrete Lean signature in the chapter.

### `\lean{AlgebraicGeometry.base_change_mate_inner_value_eq}` (chapter: `lem:base_change_mate_inner_value_eq`)
- **Lean target exists**: **yes** — `theorem base_change_mate_inner_value_eq` at line 1543.
- **Signature matches**: **yes** — blueprint describes the inner composite `θ_in` read on Spec R global sections via the Γ-pushforward dictionaries equalling `ρ : m ↦ (1 ⊗ 1) ⊗ m`. Lean statement (lines 1545–1561) has: `(gammaPushforwardTildeIso φ M).inv ≫ (moduleSpecΓFunctor R).map (unit.app ≫ pushforwardComp.hom ≫ pushforwardCongr.hom ≫ pushforwardComp.inv) ≫ (gammaPushforwardIso ψ _ ≪≫ (restrictScalars ψ).mapIso (base_change_mate_codomain_read ψ φ M)).hom = base_change_mate_inner_value ψ φ M`. This is faithful to the prose.
- **Proof follows sketch**: **partial** — blueprint proof says "by `inner_eCancel` the distribution collapses, then `base_change_mate_unit_value` + transport to `ρ`." Lean proof (lines 1569–1577) does the first step of the sketch (Γ-collapse of the transparent coherences via `gammaMap_pushforwardComp_inv_eq_id` and `gammaMap_pushforwardCongr_hom`) and then defers the residual ~150-LOC `inner_eCancel` telescoping to `sorry` at line 1577.
- **notes**: `\leanok` present before lemma block in blueprint (statement formalized, proof in progress). The sorry is **consistent** with blueprint's statement-only `\leanok`. The blocker is the absent `base_change_mate_inner_eCancel` declaration (see above) and the `base_change_mate_unit_value` + ring-transport assembly.

### `\lean{AlgebraicGeometry.base_change_mate_gstar_generator_close}` (chapter: `lem:base_change_mate_gstar_generator_close`)
- **Lean target exists**: **yes** — `theorem base_change_mate_gstar_generator_close` at line 1499.
- **Signature matches**: **yes** — blueprint (line ~2138) says: `(extendScalars ψ)(ρ) ≫ ε^alg = regroup⁻¹`. Lean statement (lines 1507–1510): `(ModuleCat.extendScalars ψ.hom).map (base_change_mate_inner_value ψ φ M) ≫ (ModuleCat.extendRestrictScalarsAdj ψ.hom).counit.app ((ModuleCat.restrictScalars inclR'.hom).obj ((ModuleCat.extendScalars inclA.hom).obj M)) = (base_change_mate_regroupEquiv ψ φ M).inv`. Faithful match. The `letI`/`let` algebra context block (lines 1501–1506) correctly reflects the implicit algebra data the blueprint states "let ιA, ιR' be the tensor inclusions."
- **Proof follows sketch**: **partial** — blueprint proof says "by extensionality on generators, LHS sends `r' ⊗ m ↦ r' · ρ(m) = (1 ⊗ r') ⊗ m`; RHS is `regroup⁻¹` by definition; agree on all generators." Lean proof (lines 1517–1532) does the `ext x` and `ModuleCat.ExtendRestrictScalarsAdj.Counit.map_apply_one_tmul` step then defers the concrete carrier computation `ρ(x) = regroupEquiv.inv (1 ⊗ₜ x)` to `sorry` at line 1532.
- **notes**: `\leanok` present before lemma block (statement formalized, proof in progress). The sorry is **consistent** with blueprint's statement-only `\leanok`. Blocker: `base_change_mate_inner_value` is def-by-tactic; its `restrictScalarsComp'App` transports resist `rw`-based equation lemmas through `ModuleCat.Hom.hom`. The comment at lines 1527–1531 correctly documents the blocker and proposes the re-break (`inner_value_apply` + `regroupEquiv_inv_one_tmul` lemmas).

### `\lean{AlgebraicGeometry.base_change_mate_gstar_counit_transport}` (chapter: `lem:base_change_mate_gstar_counit_transport`)
- **Lean target exists**: **yes** — `theorem base_change_mate_gstar_counit_transport` at line 1589.
- **Signature matches**: **yes, with orientation note** — blueprint (line ~2178) states the identity as `Π_ψ⁻¹ ∘ g^*(ε^Γ) ∘ ε_g = tilde(ε^alg) ∘ ε^Γ` (LHS = geometric counit side, RHS = algebraic counit side). Lean statement (lines 1591–1602) presents it with LHS = algebraic side (`(extendScalars ψ ⋙ tilde R').map (γ_ψ.hom.app W) ≫ tilde(ε^alg) ≫ ε^Γ`) and RHS = geometric side (`(pullback_spec_tilde_iso ψ _).inv ≫ pullback(ψ).map(ε^Γ) ≫ ε_g`). This is a left/right flip of the blueprint's presentation; mathematically equivalent (same equation, written `LHS = RHS` vs `RHS = LHS`). Not a mismatch.
- **Proof follows sketch**: **yes** — blueprint sketch says "instantiate `conjugateEquiv_counit_symm` at adjL/adjR/β, use `hpullinv : conjugate(β.hom) = pullback_spec_tilde_iso⁻¹`, split each composite counit." Lean proof (lines 1604–1627) follows this exactly: `set adjL/adjR/β`, `have hpullinv` (via `rfl`), `have huce := conjugateEquiv_counit_symm`, `rw [hpullinv] at huce`, `have hcounitL/R` (via `Adjunction.comp_counit_app`), `rw [...] at huce`, `exact huce`. No sorry.
- **notes**: **Proof COMPLETE, axiom-clean.** `\leanok` present before lemma block in blueprint. No discrepancy. This is the fully landed seam of iter-023.

---

### `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_hom_eq_id}` (chapter: `lem:gammaMap_pushforwardComp_hom_eq_id`)
- **Lean target exists**: **yes, but `private`** — `private lemma gammaMap_pushforwardComp_hom_eq_id` at line 1174. Proof complete (rfl-based, no sorry).
- **Signature matches**: **yes** — blueprint states `Γ((pushforwardComp a b).hom_M) = id`. Lean states the same. Perfect match.
- **Proof follows sketch**: **yes** — one-liner `rfl` proof, matching the blueprint's "evaluates to identity on every open."
- **notes**: The `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_hom_eq_id}` reference in the blueprint names the declaration by its **public-form fully-qualified name**. In Lean 4, `private` declarations are name-mangled; the name `AlgebraicGeometry.gammaMap_pushforwardComp_hom_eq_id` is not the actual resolved name. `sync_leanok` and the blueprint linkage system will fail to match this `\lean{...}` reference against the actual private declaration. The `\leanok` currently present (line 1561) may be stale or manually placed if it was inserted before the declaration was made `private`. See red flags.

### `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_inv_eq_id}` (chapter: `lem:gammaMap_pushforwardComp_inv_eq_id`)
- **Lean target exists**: **yes, but `private`** — `private lemma gammaMap_pushforwardComp_inv_eq_id` at line 1182. Proof complete.
- **Signature matches**: **yes** — same analysis as the hom variant.
- **Proof follows sketch**: **yes**.
- **notes**: Same private-name-mangling issue as `gammaMap_pushforwardComp_hom_eq_id`.

### `\lean{AlgebraicGeometry.gammaMap_pushforwardCongr_hom}` (chapter: `lem:gammaMap_pushforwardCongr_hom`)
- **Lean target exists**: **yes, but `private`** — `private lemma gammaMap_pushforwardCongr_hom` at line 1193. Proof complete (`subst hfg; simp`).
- **Signature matches**: **yes** — blueprint states `Γ((pushforwardCongr (f = g)).hom_M) = eqToHom (by rw [hfg])`. Lean returns `eqToHom (by rw [hfg])`. Match.
- **Proof follows sketch**: **yes**.
- **notes**: Same private-name-mangling issue. The `\leanok` at line 1603 may be synthetic/stale for the same reason.

---

## Red flags

### `\lean{...}` references to non-existent declarations
- `lem:base_change_mate_inner_unitReduce` (blueprint ~line 2000): `\lean{AlgebraicGeometry.base_change_mate_inner_unitReduce}` — no such declaration exists in the Lean file.
- `lem:base_change_mate_inner_eCancel` (blueprint ~line 2056): `\lean{AlgebraicGeometry.base_change_mate_inner_eCancel}` — no such declaration exists in the Lean file.

### `\lean{...}` names that won't resolve: `private` declarations
In Lean 4, `private` declarations receive a mangled internal name; the unmangled `AlgebraicGeometry.*` form is not a valid FQN. The following three blueprint blocks have `\lean{...}` references that name the unmangled form, which `sync_leanok` and the blueprint linkage system cannot resolve:
- `lem:gammaMap_pushforwardComp_hom_eq_id` → `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_hom_eq_id}` (Lean:1174 `private`)
- `lem:gammaMap_pushforwardComp_inv_eq_id` → `\lean{AlgebraicGeometry.gammaMap_pushforwardComp_inv_eq_id}` (Lean:1182 `private`)
- `lem:gammaMap_pushforwardCongr_hom` → `\lean{AlgebraicGeometry.gammaMap_pushforwardCongr_hom}` (Lean:1193 `private`)

The mathematical content and proofs are correct; the issue is purely the `private` keyword preventing external name resolution. Fix: either remove `private` from these three declarations (making them package-level helpers), or keep them `private` and remove the `\lean{...}` hints from the blueprint (replacing with `% LEAN INTERNAL: private lemma`).

### Sorries on in-progress proofs (expected / consistent with blueprint)
Not classified as red flags since the blueprint correctly marks only `\leanok` at statement level (not proof level) for both:
- `base_change_mate_gstar_generator_close` (Lean:1532 sorry) — blocked on `inner_value_apply` availability
- `base_change_mate_inner_value_eq` (Lean:1577 sorry) — blocked on `inner_eCancel` telescoping

---

## Unreferenced declarations (informational)

The following declarations exist in the Lean file in the gstar-chain region and have no corresponding `\lean{...}` reference in the blueprint. All are internal scaffolding:

- `base_change_mate_codomain_read_legs` (Lean:1210) — variable-leg variant of the codomain read, used by `base_change_mate_fstar_reindex_legs`. Referenced by `lem:base_change_mate_codomain_read_legs` in the blueprint but outside the gstar-chain focus of this iter.
- `base_change_mate_gstar_transpose` (Lean:1637) — has its own `\lean{...}` reference in `lem:base_change_mate_gstar_transpose`; not new this iter, not re-audited here.

No substantive declarations appear to be missing blueprint coverage.

---

## Blueprint adequacy for this file

### Coverage
- **gstar-chain blocks checked this iter**: 5 `\lean{...}` blocks in the new seam region (A-1 through C).
- **Declared**: 3/5 have Lean declarations (`inner_value_eq`, `gstar_generator_close`, `gstar_counit_transport`). 2/5 do not (`inner_unitReduce`, `inner_eCancel`).
- **Helper blocks**: 3 additional `\lean{...}` blocks for the Γ-collapse helpers; all three have Lean declarations but with private-name mismatch.

### Proof-sketch depth
**Partially under-specified** for `inner_unitReduce` and `inner_eCancel`. The mathematical narrative in both blocks is clear and correct. The failure is that neither block provides a `% LEAN SIGNATURE` comment or states the exact Lean type (source object, target object, explicit `letI` context, intermediate types after each of the four factors). The prose describes the *mathematical* content (four Γ-image factors; three-factor cancellation against `Θ_tgt`), but for `inner_unitReduce` the domain and codomain of each factor, and for `inner_eCancel` the exact statement after cancellation, are not pinned. A prover cannot write a valid `theorem` stub without guessing the intermediate `ModuleCat R` object types.

**Adequate** for the three proved/in-progress theorems (`inner_value_eq`, `gstar_generator_close`, `gstar_counit_transport`): the proof sketches are at the right level and the Lean proofs follow them faithfully.

### Hint precision
- **`inner_unitReduce`, `inner_eCancel`**: **loose** — `\lean{...}` names the declaration but no `% LEAN SIGNATURE` hint. The prose alone does not uniquely determine the Lean type signature.
- **Three private helpers**: **wrong** in the sense of not resolving (mangled name). Mathematically correct.
- **Remaining gstar-chain blocks**: **precise** — the `% LEAN SIGNATURE` comment in `lem:base_change_mate_gstar_transpose` (lines ~2237–2265) gives a fully elaborated hint and correctly pins the type.

### Generality
**Matches need** — no parallel APIs were introduced; the formalization uses exactly the abstractions the blueprint specifies.

### Recommended chapter-side actions
1. **`lem:base_change_mate_inner_unitReduce`**: Add a `% LEAN SIGNATURE` block giving the exact Lean statement (explicit `letI` algebra contexts; the source object `(moduleSpecΓFunctor R).obj ((pushforward (Spec.map φ)).obj (tilde M))`; the target, which is the four-factor composite in `ModuleCat R`; the result equality type). Without this pin, no prover can write the stub.
2. **`lem:base_change_mate_inner_eCancel`**: Add a `% LEAN SIGNATURE` block giving the exact statement post-cancellation. The surviving factor is the affine `(Spec ιA)`-unit conjugated by the tilde/Γ dictionaries over `Spec A`, composed with `base_change_mate_codomain_read`; the exact `ModuleCat R` morphism type needs spelling out.
3. **Three private helpers**: Either remove `private` from `gammaMap_pushforwardComp_hom_eq_id`, `gammaMap_pushforwardComp_inv_eq_id`, `gammaMap_pushforwardCongr_hom` in the Lean file so the `\lean{...}` references resolve, or replace the `\lean{...}` references with a `% LEAN INTERNAL: private lemma, not tracked by sync_leanok` comment.

---

## Severity summary

### must-fix-this-iter
1. **`lem:base_change_mate_inner_unitReduce`**: `\lean{...}` reference names a non-existent declaration; blueprint block has no `\leanok`, no signature hint, and prose alone is insufficient to derive the Lean type. Blueprint adequacy failure — chapter is under-specified at the signature level for this block.
2. **`lem:base_change_mate_inner_eCancel`**: Same as above. Both blocks gate the `inner_value_eq` proof (which defers the `inner_eCancel` telescoping at line 1577) and, transitively, `gstar_transpose`.

### major
3. **Three private-declaration `\lean{...}` mismatches** (`gammaMap_pushforwardComp_hom_eq_id`, `gammaMap_pushforwardComp_inv_eq_id`, `gammaMap_pushforwardCongr_hom`): declarations are proved and correct; the `private` keyword makes the `\lean{...}` names unresolvable by `sync_leanok` and the blueprint linkage system. The `\leanok` markers on these blocks may silently become stale. Fixable in-place (remove `private` or adjust the blueprint references).

### minor
*(none)*

### known in-progress (not classified as severity, consistent with blueprint state)
- `base_change_mate_gstar_generator_close`: sorry at line 1532; blueprint has only statement-level `\leanok`. Expected state; blocker documented precisely.
- `base_change_mate_inner_value_eq`: sorry at line 1577; same. Residual is the `inner_eCancel` telescoping deferred above.

**Overall verdict**: The three new theorem *statements* are faithful to the blueprint. `gstar_counit_transport` is the sole fully closed proof this iter. The chapter has two must-fix blueprint adequacy gaps (`inner_unitReduce`, `inner_eCancel` missing Lean signatures) and a major `private`-name cluster that will silently break `sync_leanok` tracking for three proved helpers.
