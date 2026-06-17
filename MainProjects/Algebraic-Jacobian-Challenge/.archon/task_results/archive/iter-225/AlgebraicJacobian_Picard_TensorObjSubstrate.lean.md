# AlgebraicJacobian/Picard/TensorObjSubstrate.lean — iter-225 (mathlib-build)

## Summary
- Declarations added: **1 axiom-clean** — `AlgebraicGeometry.Scheme.Modules.dual` (line ~1555).
- Declarations blocked: **1** — the SECONDARY descended evaluation `dual_eval` (built & compiling,
  but sorry-TRANSITIVE → removed; see below). SECONDARY `dual_isLocallyTrivial` not attempted
  (needs a substantial new dual-of-restriction linchpin; hand-off below).
- Sorry count across file: **unchanged** (`dual` is no-sorry infra; project sorry stays 80 as planned).
- Build: GREEN (only the known/deferred `Sheaf.val` → `ObjectProperty.obj` deprecation warnings).

## PRIMARY — `AlgebraicGeometry.Scheme.Modules.dual` (RESOLVED, axiom-clean)
- **Approach:** Exact dual analogue of the in-file `tensorObj` (L1524). Sheafify the (sub-step-3,
  axiom-clean) presheaf dual:
  ```
  noncomputable def dual {X : Scheme.{u}} (M : X.Modules) : X.Modules :=
    ((PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).obj
        (PresheafOfModules.dual (R₀ := X.presheaf) M.val) : SheafOfModules X.ringCatSheaf)
  ```
- **The "CommRingCat/RingCat base bridge" obstacle was a NON-ISSUE.** The objective flagged this as
  the one real obstacle, but `X.presheaf : TopCat.Presheaf CommRingCat ↑X.toPresheafedSpace` is
  ALREADY `CommRingCat`-valued over the single-universe topological site `Opens ↑X` (verified via
  hover: `_root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)`). So `X.presheaf` IS
  exactly the `R₀ : Dᵒᵖ ⥤ CommRingCat.{u}` (`D = Opens ↑X`, `[Category.{u,u} D]`) that
  `PresheafOfModules.dual` requires — `(R₀ := X.presheaf)` resolves with no re-bridging. `tensorObj`
  already takes `(R := X.presheaf)` over the same CommRingCat presheaf, and
  `X.ringCatSheaf.val = X.presheaf ⋙ forget₂ CommRingCat RingCat` definitionally, so the
  `sheafification (𝟙 X.ringCatSheaf.val)).obj` accepts `PresheafOfModules.dual M.val` verbatim.
- **Result:** RESOLVED. `lean_verify AlgebraicGeometry.Scheme.Modules.dual` →
  `{propext, Classical.choice, Quot.sound}`. No manual `Presheaf.IsSheaf` descent needed
  (sheafification lands in `SheafOfModules`). Ready for blueprint `\leanok` on
  `lem:internal_hom_isSheaf` / `\lean{AlgebraicGeometry.Scheme.Modules.dual}` (sync_leanok will set it).

## SECONDARY item 2 — descended evaluation `M ⊗_X dual M ⟶ 𝒪_X` (BUILT then REMOVED: sorry-transitive)
- **Approach (compiles, no sorry token):** the exact dual analogue of how `tensorObj_assoc_iso`
  closes — write `a = sheafification`, `η = sheafificationAdjunction.unit`,
  `Dpre = PresheafOfModules.dual M.val`. The left-whiskered unit `M.val ◁ η.app Dpre` lies in `J.W`
  (`η = toSheafify ∈ J.W`), `a.map` of it is iso (`isIso_sheafification_map_of_W`) with codomain
  exactly `tensorObj M (dual M)`; compose its inverse with `a.map (internalHomEval M.val)` and the
  counit `a.obj 𝟙_ ≅ 𝒪_X`. **This typechecked and compiled cleanly.**
- **Why REMOVED:** `lean_verify` showed `sorryAx` in the ancestry. The whiskering lemma
  `PresheafOfModules.W_whiskerLeft_of_W` (verified: axioms include `sorryAx`) routes through the
  route-(e) residual `isLocallyInjective_whiskerLeft_of_W` (L641, an open `sorry` — the d.2
  stalk-⊗ commutation gap). This is the **same** unclosed residual the associator
  `tensorObj_assoc_iso` is sorry-transitive through. A flatness-free, axiom-clean descended eval for
  ARBITRARY `M` is therefore genuinely blocked on `isLocallyInjective_whiskerLeft_of_W`.
  Per the mathlib-build invariant ("any `sorryAx` in the ancestry ⇒ not axiom-clean"), I removed it
  rather than ship sorry-transitive output.
- **Dead end to avoid:** the flat variant `W_whiskerLeft_of_flat` is axiom-clean but needs sectionwise
  flatness `∀ U, Module.Flat (𝒪_X(U)) (M.val(U))`, FALSE for line bundles over non-affine opens
  (the file's own iter-212 finding) — no substitute. There is no presheaf→sheafified map back on the
  dual factor, so the eval cannot be defined without the whiskered-unit iso. **This decl becomes a
  clean ~10-line axiom-clean add the moment `isLocallyInjective_whiskerLeft_of_W` (d.2) is closed** —
  the construction above is correct and ready; re-paste it then.

## SECONDARY item 1 — `dual_isLocallyTrivial` (NOT ADDED)
- **Why not attempted:** requires (a) a dual-of-restriction linchpin `(dual L)|_U ≅ dual_U (L|_U)`
  (the internal-hom analogue of `tensorObj_restrict_iso`, itself a multi-iter linchpin), plus
  (b) dual-preserves-isos and (c) `dual_U(𝒪_U) ≅ 𝒪_U`. (a) is a substantial new build, not a clean
  1-iter add, and likely re-routes through the same sheafification/whiskering machinery. Deferred as
  a precise hand-off rather than starting a build that won't land axiom-clean this iter.

## Why I stopped
**Real progress:** 1 axiom-clean declaration — `AlgebraicGeometry.Scheme.Modules.dual` (line ~1555),
`{propext, Classical.choice, Quot.sound}`, build GREEN. This is the full sub-step-4 PRIMARY success
(the directive: "Retiring just PRIMARY `dual` is full sub-step-4 success").

**Partial/blocked:** Both SECONDARY items are blocked, not by budget but by a precise, pre-existing
open residual:
- `dual_eval` (descended evaluation): construction is correct and compiles, but is sorry-transitive
  through `isLocallyInjective_whiskerLeft_of_W` (L641, the d.2 stalk-⊗ gap) — the SAME residual the
  associator depends on. Removed to keep output axiom-clean. Ready to re-add once d.2 lands.
- `dual_isLocallyTrivial`: needs the new dual-of-restriction linchpin (a) above; substantial.

**Next step / next sub-step:** sub-step 5 `exists_tensorObj_inverse` (FORBIDDEN this iter) is the
80→79 mover and will consume `dual` (+ the descended eval once d.2 is closed). The genuine remaining
math blocker for the eval/inverse lane is `isLocallyInjective_whiskerLeft_of_W` (the stalk-⊗
commutation `(F ⊗ᵖ M)_x ≅ F_x ⊗_{R_x} M_x`, Mathlib-absent at the pinned commit).

## Blueprint marker note (for review agent / sync)
- `lem:internal_hom_isSheaf` / `\lean{AlgebraicGeometry.Scheme.Modules.dual}` is now formalized and
  axiom-clean — eligible for `\leanok` (sync_leanok deterministic pass will apply it).
