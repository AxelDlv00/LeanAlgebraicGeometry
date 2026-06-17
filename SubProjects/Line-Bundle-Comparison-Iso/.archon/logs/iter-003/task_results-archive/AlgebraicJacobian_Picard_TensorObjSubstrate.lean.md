# AlgebraicJacobian/Picard/TensorObjSubstrate.lean

## sheafificationCompPullback_comp_tail (line 2467)
### Attempt 1
- **Approach:** Continued from the existing R1/R5-recovery reduction and checked the available local facts at the remaining tail goal.
- **Result:** PARTIAL. The goal still remains at the expanded composite-adjunction unit cocycle.
- **Dead end warning:** Direct `aesop_cat`, reassociation, `← Functor.map_comp`, and sectionwise `hom_ext`/`ModuleCat.hom_ext` do not close the reduced tail. The sectionwise goal is not definitional after the current normalization.
- **Lemmas found/used:** `leftAdjointUniqUnitEta_app` elaborates for both the `f` layer at `P` and the `h` layer at `(PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj P`; this confirms the advertised unit-recovery bricks line up.

## sheafificationCompPullback_comp (line 2636)
### Attempt 1
- **Approach:** Implemented the non-circular fallback scaffold from `analogies/d3-mate271.md`: instantiate `Adjunction.leftAdjointCompNatTrans_assoc` for `sheafification_X`, sheaf pullback by `f`, and sheaf pullback by `h`, with alternate adjunctions `prePull f ⋙ sheafification_Y`, sheaf pullback by `h ≫ f`, and `prePull (h ≫ f) ⋙ sheafification_Z`.
- **Result:** PARTIAL. Added checked local terms `τ012`, `τ123`, `τ013`, `τ023`, proved the right-adjoint coherence by `ext A; rfl`, and obtained `hAssocComponent := congr_app (Adjunction.leftAdjointCompNatTrans_assoc ...) P`.
- **Key insight:** Three identifications are definitional in Lean: `τ012` gives `sheafificationCompPullback f`, `τ013` gives `sheafificationCompPullback (h ≫ f)`, and `τ123` gives `SheafOfModules.pullbackComp ... .hom`. The remaining splice is the mixed comparison `(conjugateEquiv adj03 (adj02.comp adj23)).symm τ023`, which should be identified with `sheafificationCompPullback h` followed by sheafified `PresheafOfModules.pullbackComp.hom`.
- **Next step:** Prove the mixed-comparison component using the nested associativity instance for presheaf pullback by `f`, sheafification on `Y`, and sheaf pullback by `h`. I tested this route: it produces the right component equality, but the final `simpa` still needs explicit simplification/rearrangement of the functor-category associator component.

## pullbackTensorMap_restrict (line 2824)
### Attempt 1
- **Approach:** Deferred as planned because `sheafificationCompPullback_comp` is still not closed.
- **Result:** NOT ATTEMPTED beyond preserving the existing opened paste-ready proof.

## exists_tensorObj_inverse (line 690)
### Attempt 1
- **Approach:** Left untouched per PROGRESS; this is gated on the downstream DUAL chain and should not be solved in this file.
- **Result:** DEFERRED.

## Verification
- `lake env lean AlgebraicJacobian/Picard/TensorObjSubstrate.lean` exits 0.
- Remaining warnings include the existing `Sheaf.val` deprecations, style warnings, and the three expected `declaration uses sorry` warnings at `exists_tensorObj_inverse`, `sheafificationCompPullback_comp_tail`, and `pullbackTensorMap_restrict`.

## Needs blueprint entry
- None. No new declarations were introduced; the new work is local proof scaffolding inside `sheafificationCompPullback_comp`.
