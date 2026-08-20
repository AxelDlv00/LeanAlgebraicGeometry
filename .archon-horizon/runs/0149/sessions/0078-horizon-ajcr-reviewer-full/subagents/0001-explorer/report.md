Fst audit complete. The exact reusable transport boundary is:

```lean
private theorem comp_fst_transport
    {X A B R D E O Z : Scheme.{u}}
    (t : X ⟶ A) (f : A ⟶ B)
    (i : B ⟶ R) (p : R ⟶ Z) (q : B ⟶ Z) (m : X ⟶ Z)
    (l : X ⟶ D) (c : D ⟶ E) (a : D ⟶ O)
    (r : E ⟶ R) (s : E ⟶ Z) (tf e : O ⟶ Z)
    (hι : i ≫ p = q) (ht : t ≫ f ≫ q = m)
    (hmap : r ≫ p = s) (hcongr : c ≫ s = a ≫ e)
    (hbridge : tf = e) (hflat : l ≫ a ≫ tf = m) :
    t ≫ f ≫ i ≫ p = l ≫ c ≫ r ≫ p := by
  calc
    _ = t ≫ f ≫ q := congrArg (fun x => t ≫ f ≫ x) hι
    _ = m := ht
    _ = l ≫ a ≫ tf := hflat.symm
    _ = l ≫ a ≫ e := congrArg (fun x => l ≫ a ≫ x) hbridge
    _ = l ≫ c ≫ s := congrArg (fun x => l ≫ x) hcongr.symm
    _ = l ≫ c ≫ r ≫ p :=
      congrArg (fun x => l ≫ c ≫ x) hmap.symm
```

Use explicit positional or named arrows from `G.t`, `G.f`, the chart congruence, chart projection, flattening iso, overlap congruence, overlap projection, and right restriction map. The extra Fst bridge is `hbridge := glueData_t_comp_f_eq_spec_rightRestriction ...`; the flattening endpoint is `gluingOverlapFlatteningIso_hom_comp_fst_comp_t_f ...`. Keep the Fst theorem statement right-associated and remove its initial whole-goal `simp [Category.assoc]` when applying this helper.
