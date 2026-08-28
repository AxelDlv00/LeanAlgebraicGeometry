The full construction compiled with `lean_run_code`:

```lean
noncomputable def degreeZeroDivisorClasses (hzero : PrincipalDivisorsHaveDegreeZero) :
    AddSubgroup (DivisorClassGroup (k := k) (X := X)) :=
  (degreeClass hzero).ker

@[simp] theorem mem_degreeZeroDivisorClasses_iff (hzero) (a) :
    a ∈ degreeZeroDivisorClasses hzero ↔ degreeClass hzero a = 0 :=
  AddMonoidHom.mem_ker

@[simp] theorem divisorClass_mem_degreeZeroDivisorClasses_iff (hzero)
    (D : CurveDivisor k X) :
    divisorClass D ∈ degreeZeroDivisorClasses hzero ↔
      CurveDivisor.degree D = 0 := by
  rw [mem_degreeZeroDivisorClasses_iff, degreeClass_divisorClass]

noncomputable def pointClassHom
    (x : {x : X.left // x ≠ genericPoint X.left}) :
    ℤ →+ DivisorClassGroup (k := k) (X := X) :=
  divisorClass.comp (Finsupp.singleAddHom x)

@[simp] theorem degreeClass_pointClassHom (hzero) (x) (n : ℤ) :
    degreeClass hzero (pointClassHom (k := k) (X := X) x n) = n := by
  rw [pointClassHom_apply, degreeClass_divisorClass,
    CurveDivisor.degree_single]

theorem degreeClass_surjective_of_point (hzero) (x) :
    Function.Surjective (degreeClass hzero) := by
  intro n
  exact ⟨pointClassHom (k := k) (X := X) x n,
    degreeClass_pointClassHom hzero x n⟩

theorem pointClassHom_eq_zsmul (x) (n : ℤ) :
    pointClassHom (k := k) (X := X) x n =
      n • divisorClass (Finsupp.single x 1) := by
  simpa using
    (map_zsmul (pointClassHom (k := k) (X := X) x) n (1 : ℤ))
```

The decomposition then closes with `map_sub`, `sub_self`, and `abel`. No API obstacle was found; existence of the non-generic point remains an explicit hypothesis. Horizon search also found analogous AJCR point-divisor APIs, but no sibling dependency is needed.
