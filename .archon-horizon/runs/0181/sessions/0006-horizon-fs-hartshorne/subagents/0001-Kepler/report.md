The immediate frontier is to close Hartshorne II.2 rather than pursue the generic presheaf node.

Recommended next theorem:

```lean
@[reassoc]
theorem affineSpecMap_stalkIso_naturality {R S : CommRingCat}
    (f : R ⟶ S) (p : PrimeSpectrum S) :
    (affineSpec_stalk_iso R (p.comap f.hom)).hom ≫
      (CommRingCat.ofHom <| Localization.localRingHom
        (p.comap f.hom).asIdeal p.asIdeal f.hom rfl) ≫
      (affineSpec_stalk_iso S p).inv =
        (Spec.map f).stalkMap p := by
  exact Scheme.localRingHom_comp_stalkIso f p
```

Also wrap `StructureSheaf.comap_basicOpen f r`, which identifies the induced sheaf map on `D(r)` with the ordinary localization map.

The main graph gap is explicit binding: `prop:II-2-2` currently has no formalizes edges despite all three clauses being proved. Bind its stalk, basic-open, and global-section declarations; similarly bind the new affine map declarations to `prop:II-2-3`. Existing II.2.3 links only reference the Chapter I coordinate-ring spectrum map family and are incomplete.

No files were edited.
