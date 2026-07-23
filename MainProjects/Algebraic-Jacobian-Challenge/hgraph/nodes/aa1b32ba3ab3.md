---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.exists_res_eq_pow_smul_of_isCompact
docstring: '**Surjectivity half of qcqs section localization** (Stacks 01P0-style,
  `surj` engine).

  For a quasi-coherent `M` on `X`, `g ∈ Γ(X, W)`, and a quasi-compact open `U ≤ W`
  inside the

  quasi-separated open `W`, every section `y ∈ Γ(M, U ⊓ D(g))` is, after multiplication
  by a

  power of `g`, the restriction of a section over `U`. Induction on the compact open
  `U`: the

  affine case is the gap2 keystone''s `surj`, and the step glues the two normalized
  candidate

  sections over `{S, V}` after killing their difference on the quasi-compact overlap
  `S ⊓ V`

  with the torsion half. Project-local.'
file: AlgebraicJacobian/Picard/QuotScheme.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.exists_res_eq_pow_smul_of_isCompact
type: lean
updated: '2026-07-24T03:02:11'
---
theorem exists_res_eq_pow_smul_of_isCompact
    (M : X.Modules) [M.IsQuasicoherent] {W : X.Opens} (g : Γ(X, W))
    (hsep : IsQuasiSeparated (W : Set X))
    (U : X.Opens) (hU : IsCompact (U : Set X)) :
    ∀ (hUW : U ≤ W) (y : Γ(M, U ⊓ X.basicOpen g)),
      ∃ (x : Γ(M, U)) (n : ℕ),
        M.presheaf.map (homOfLE (inf_le_left : U ⊓ X.basicOpen g ≤ U)).op x
          = X.presheaf.map (homOfLE ((inf_le_left : U ⊓ X.basicOpen g ≤ U).trans hUW)).op g ^ n
            • y := by
  refine compact_open_induction_on (P := fun U => ∀ (hUW : U ≤ W)
      (y : Γ(M, U ⊓ X.basicOpen g)),
      ∃ (x : Γ(M, U)) (n : ℕ),
        M.presheaf.map (homOfLE (inf_le_left : U ⊓ X.basicOpen g ≤ U)).op x
          = X.presheaf.map (homOfLE ((inf_le_left : U ⊓ X.basicOpen g ≤ U).trans hUW)).op g ^ n
            • y) U hU ?_ ?_
  · intro _ y
    refine ⟨0, 0, ?_⟩
    rw [map_zero, pow_zero, one_smul]
    exact (section_eq_zero_of_le_bot M inf_le_left y).symm
  · intro S hS V IH hUW y
    have hSW : S ≤ W := le_sup_left.trans hUW
    have hVW : V.1 ≤ W := le_sup_right.trans hUW
    set gV : Γ(X, V.1) := X.presheaf.map (homOfLE hVW).op g with hgV
    have hB1eq : X.basicOpen gV = V.1 ⊓ X.basicOpen g := X.basicOpen_res g (homOfLE hVW).op
    have hB1W : X.basicOpen gV ≤ W := (X.basicOpen_le gV).trans hVW
    have hB1A : X.basicOpen gV ≤ (S ⊔ V.1) ⊓ X.basicOpen g :=
      hB1eq.trans_le (inf_le_inf le_sup_right le_rfl)
    -- S side: the induction hypothesis
    set yS : Γ(M, S ⊓ X.basicOpen g) :=
      M.presheaf.map (homOfLE (inf_le_inf le_sup_left le_rfl :
        S ⊓ X.basicOpen g ≤ (S ⊔ V.1) ⊓ X.basicOpen g)).op y with hyS
    obtain ⟨xS, n₁, hn₁⟩ := IH hSW yS
    -- V side: the affine keystone's surjectivity
    letI : Module Γ(X, V.1) Γ(M, X.basicOpen gV) :=
      Module.compHom _ (algebraMap Γ(X, V.1) Γ(X, X.basicOpen gV))
    haveI : IsScalarTower Γ(X, V.1) Γ(X, X.basicOpen gV) Γ(M, X.basicOpen gV) :=
      IsScalarTower.of_algebraMap_smul (fun _ _ => rfl)
    haveI := isLocalizedModule_basicOpen M V.2 gV
    set yV : Γ(M, X.basicOpen gV) := M.presheaf.map (homOfLE hB1A).op y with hyV
    obtain ⟨⟨xV, c⟩, hc⟩ := IsLocalizedModule.surj (S := Submonoid.powers gV)
      (f := restrictBasicOpenₗ M gV) yV
    have hn₂ : gV ^ c.2.choose = (c : Γ(X, V.1)) := c.2.choose_spec
    set n₂ := c.2.choose with hn₂def
    -- the compHom action unfolds to the restricted scalar acting through the native action
    have hc' : X.presheaf.map (homOfLE (X.basicOpen_le gV)).op (c : Γ(X, V.1)) • yV
        = M.presheaf.map (homOfLE (X.basicOpen_le gV)).op xV := hc
    have hres : X.presheaf.map (homOfLE (X.basicOpen_le gV)).op gV
        = X.presheaf.map (homOfLE hB1W).op g :=
      (congrArg (X.presheaf.map (homOfLE (X.basicOpen_le gV)).op) hgV).trans
        (resRing_res hVW (X.basicOpen_le gV) hB1W g)
    have hcV : X.presheaf.map (homOfLE hB1W).op g ^ n₂ • yV
        = M.presheaf.map (homOfLE (X.basicOpen_le gV)).op xV := by
      rw [← hc', ← hn₂, map_pow, hres]
    -- normalize both candidates to the common exponent `n = max n₁ n₂`
    set n := max n₁ n₂ with hn
    set xS' : Γ(M, S) := X.presheaf.map (homOfLE hSW).op g ^ (n - n₁) • xS with hxS'
    set xV' : Γ(M, V.1) := gV ^ (n - n₂) • xV with hxV'
    have hS' : M.presheaf.map (homOfLE (inf_le_left : S ⊓ X.basicOpen g ≤ S)).op xS'
        = X.presheaf.map (homOfLE ((inf_le_left : S ⊓ X.basicOpen g ≤ S).trans hSW)).op g ^ n
          • yS := by
      rw [hxS', map_smul, map_pow,
        resRing_res hSW (inf_le_left : S ⊓ X.basicOpen g ≤ S)
          ((inf_le_left : S ⊓ X.basicOpen g ≤ S).trans hSW) g,
        hn₁, ← mul_smul, ← pow_add, Nat.sub_add_cancel (le_max_left n₁ n₂)]
    have hV' : M.presheaf.map (homOfLE (X.basicOpen_le gV)).op xV'
        = X.presheaf.map (homOfLE hB1W).op g ^ n • yV := by
      rw [hxV', map_smul, map_pow, hres, ← hcV, ← mul_smul, ← pow_add,
        Nat.sub_add_cancel (le_max_right n₁ n₂)]
    clear_value xS' xV'
    -- the overlap `O = S ⊓ V` is quasi-compact inside the quasi-separated `W`
    have hO : IsCompact ((S ⊓ V.1 : X.Opens) : Set X) := by
      rw [TopologicalSpace.Opens.coe_inf]
      exact hsep (S : Set X) (V.1 : Set X) (fun a ha => hSW ha) S.isOpen hS
        (fun a ha => hVW ha) V.1.isOpen V.2.isCompact
    have hOW : S ⊓ V.1 ≤ W := inf_le_left.trans hSW
    -- the difference of the two normalized candidates dies on `O ⊓ D(g)` …
    set δ : Γ(M, S ⊓ V.1) :=
      M.presheaf.map (homOfLE (inf_le_left : S ⊓ V.1 ≤ S)).op xS'
        - M.presheaf.map (homOfLE (inf_le_right : S ⊓ V.1 ≤ V.1)).op xV' with hδ
    have hODB1 : (S ⊓ V.1) ⊓ X.basicOpen g ≤ X.basicOpen gV :=
      (inf_le_inf inf_le_right le_rfl).trans hB1eq.ge
    have hδ0 : M.presheaf.map
        (homOfLE (inf_le_left : (S ⊓ V.1) ⊓ X.basicOpen g ≤ S ⊓ V.1)).op δ = 0 := by
      rw [hδ, map_sub]
      have eS : M.presheaf.map
          (homOfLE (inf_le_left : (S ⊓ V.1) ⊓ X.basicOpen g ≤ S ⊓ V.1)).op
            (M.presheaf.map (homOfLE (inf_le_left : S ⊓ V.1 ≤ S)).op xS')
          = X.presheaf.map (homOfLE ((inf_le_left.trans hOW) :
              (S ⊓ V.1) ⊓ X.basicOpen g ≤ W)).op g ^ n
            • M.presheaf.map (homOfLE ((inf_le_inf inf_le_left le_rfl).trans
                (inf_le_inf le_sup_left le_rfl)) :
                (S ⊓ V.1) ⊓ X.basicOpen g ⟶ (S ⊔ V.1) ⊓ X.basicOpen g).op y := by
        rw [res_res M (inf_le_left : S ⊓ V.1 ≤ S)
          (inf_le_left : (S ⊓ V.1) ⊓ X.basicOpen g ≤ S ⊓ V.1)
          ((inf_le_inf inf_le_left le_rfl).trans inf_le_left), ← res_res M
          (inf_le_left : S ⊓ X.basicOpen g ≤ S)
          (inf_le_inf inf_le_left le_rfl :
            (S ⊓ V.1) ⊓ X.basicOpen g ≤ S ⊓ X.basicOpen g)
          ((inf_le_inf inf_le_left le_rfl).trans inf_le_left), hS', map_smul, map_pow,
          resRing_res (inf_le_left.trans hSW) (inf_le_inf inf_le_left le_rfl)
            (inf_le_left.trans hOW) g, hyS, res_res M _ _ ((inf_le_inf inf_le_left le_rfl).trans
              (inf_le_inf le_sup_left le_rfl))]
      have eV : M.presheaf.map
          (homOfLE (inf_le_left : (S ⊓ V.1) ⊓ X.basicOpen g ≤ S ⊓ V.1)).op
            (M.presheaf.map (homOfLE (inf_le_right : S ⊓ V.1 ≤ V.1)).op xV')
          = X.presheaf.map (homOfLE ((inf_le_left.trans hOW) :
              (S ⊓ V.1) ⊓ X.basicOpen g ≤ W)).op g ^ n
            • M.presheaf.map (homOfLE ((inf_le_inf inf_le_left le_rfl).trans
                (inf_le_inf le_sup_left le_rfl)) :
                (S ⊓ V.1) ⊓ X.basicOpen g ⟶ (S ⊔ V.1) ⊓ X.basicOpen g).op y := by
        rw [res_res M (inf_le_right : S ⊓ V.1 ≤ V.1)
          (inf_le_left : (S ⊓ V.1) ⊓ X.basicOpen g ≤ S ⊓ V.1)
          ((inf_le_left : (S ⊓ V.1) ⊓ X.basicOpen g ≤ S ⊓ V.1).trans inf_le_right), ← res_res M
          (X.basicOpen_le gV) hODB1
          ((inf_le_left : (S ⊓ V.1) ⊓ X.basicOpen g ≤ S ⊓ V.1).trans inf_le_right), hV',
          map_smul, map_pow,
          resRing_res hB1W hODB1 (inf_le_left.trans hOW) g, hyV,
          res_res M hB1A hODB1 ((inf_le_inf inf_le_left le_rfl).trans
            (inf_le_inf le_sup_left le_rfl))]
      rw [eS, eV, sub_self]
    -- … so a power of `g` equalizes them on the overlap (torsion half)
    obtain ⟨m, hm⟩ := exists_pow_smul_res_eq_zero_of_isCompact M g (S ⊓ V.1) hO hOW δ hδ0
    have hglue : M.presheaf.map (homOfLE (inf_le_left : S ⊓ V.1 ≤ S)).op
          (X.presheaf.map (homOfLE hSW).op g ^ m • xS')
        = M.presheaf.map (homOfLE (inf_le_right : S ⊓ V.1 ≤ V.1)).op
          (gV ^ m • xV') := by
      have h1 : X.presheaf.map (homOfLE hOW).op g ^ m
            • M.presheaf.map (homOfLE (inf_le_left : S ⊓ V.1 ≤ S)).op xS'
          - X.presheaf.map (homOfLE hOW).op g ^ m
            • M.presheaf.map (homOfLE (inf_le_right : S ⊓ V.1 ≤ V.1)).op xV' = 0 := by
        rw [← smul_sub, ← hδ]; exact hm
      have h2 := sub_eq_zero.mp h1
      have hL : M.presheaf.map (homOfLE (inf_le_left : S ⊓ V.1 ≤ S)).op
            (X.presheaf.map (homOfLE hSW).op g ^ m • xS')
          = X.presheaf.map (homOfLE hOW).op g ^ m
            • M.presheaf.map (homOfLE (inf_le_left : S ⊓ V.1 ≤ S)).op xS' := by
        rw [map_smul, map_pow, resRing_res hSW (inf_le_left : S ⊓ V.1 ≤ S) hOW g]
      have hR : M.presheaf.map (homOfLE (inf_le_right : S ⊓ V.1 ≤ V.1)).op
            (gV ^ m • xV')
          = X.presheaf.map (homOfLE hOW).op g ^ m
            • M.presheaf.map (homOfLE (inf_le_right : S ⊓ V.1 ≤ V.1)).op xV' := by
        rw [map_smul, map_pow,
          (congrArg (X.presheaf.map (homOfLE (inf_le_right : S ⊓ V.1 ≤ V.1)).op) hgV).trans
            (resRing_res hVW (inf_le_right : S ⊓ V.1 ≤ V.1) hOW g)]
      rw [hL, hR]
      exact h2
    -- compatibility of the two candidates on the overlaps
    have hcompat : TopCat.Presheaf.IsCompatible M.presheaf
        (fun b : Bool => cond b S V.1)
        (fun b => Bool.rec (motive := fun b => Γ(M, cond b S V.1))
          (gV ^ m • xV') (X.presheaf.map (homOfLE hSW).op g ^ m • xS') b) := by
      intro i j
      cases i <;> cases j
      · exact congrArg (fun (h : V.1 ⊓ V.1 ⟶ V.1) => M.presheaf.map h.op (gV ^ m • xV'))
          (Subsingleton.elim _ _)
      · -- `V` against `S`: transport `hglue` along `V ⊓ S ≤ S ⊓ V`
        show M.presheaf.map (homOfLE (inf_le_left : V.1 ⊓ S ≤ V.1)).op (gV ^ m • xV')
          = M.presheaf.map (homOfLE (inf_le_right : V.1 ⊓ S ≤ S)).op
              (X.presheaf.map (homOfLE hSW).op g ^ m • xS')
        rw [← res_res M (inf_le_right : S ⊓ V.1 ≤ V.1)
            (le_inf inf_le_right inf_le_left : V.1 ⊓ S ≤ S ⊓ V.1) inf_le_left,
          ← res_res M (inf_le_left : S ⊓ V.1 ≤ S)
            (le_inf inf_le_right inf_le_left : V.1 ⊓ S ≤ S ⊓ V.1) inf_le_right, hglue]
      · -- `S` against `V`: `hglue`
        show M.presheaf.map (homOfLE (inf_le_left : S ⊓ V.1 ≤ S)).op
              (X.presheaf.map (homOfLE hSW).op g ^ m • xS')
          = M.presheaf.map (homOfLE (inf_le_right : S ⊓ V.1 ≤ V.1)).op (gV ^ m • xV')
        exact hglue
      · exact congrArg (fun (h : S ⊓ S ⟶ S) => M.presheaf.map h.op
            (X.presheaf.map (homOfLE hSW).op g ^ m • xS'))
          (Subsingleton.elim _ _)
    -- glue the two candidates over the cover `{S, V}` of `S ⊔ V`
    obtain ⟨x', hx', -⟩ := TopCat.Sheaf.existsUnique_gluing'
      (⟨M.presheaf, M.isSheaf⟩ : TopCat.Sheaf Ab X)
      (fun b : Bool => cond b S V.1) (S ⊔ V.1)
      (fun b => homOfLE (show cond b S V.1 ≤ S ⊔ V.1 by
        cases b
        · exact le_sup_right
        · exact le_sup_left))
      (sup_le (le_iSup (fun b : Bool => cond b S V.1) true)
        (le_iSup (fun b : Bool => cond b S V.1) false))
      (fun b => Bool.rec (motive := fun b => Γ(M, cond b S V.1))
        (gV ^ m • xV') (X.presheaf.map (homOfLE hSW).op g ^ m • xS') b) hcompat
    -- the glued section is the required witness at exponent `n + m`
    refine ⟨x', n + m, ?_⟩
    have hxS'' := hx' true
    have hxV'' := hx' false
    refine TopCat.Sheaf.eq_of_locally_eq' (⟨M.presheaf, M.isSheaf⟩ : TopCat.Sheaf Ab X)
      (fun b : Bool => cond b (S ⊓ X.basicOpen g) (X.basicOpen gV))
      ((S ⊔ V.1) ⊓ X.basicOpen g)
      (fun b => homOfLE (show cond b (S ⊓ X.basicOpen g) (X.basicOpen gV)
          ≤ (S ⊔ V.1) ⊓ X.basicOpen g by
        cases b
        · exact hB1A
        · exact inf_le_inf le_sup_left le_rfl))
      (by
        refine le_trans (le_of_eq ?_) (sup_le
          (le_iSup (fun b : Bool => cond b (S ⊓ X.basicOpen g) (X.basicOpen gV)) true)
          (le_iSup (fun b : Bool => cond b (S ⊓ X.basicOpen g) (X.basicOpen gV)) false))
        rw [hB1eq, inf_sup_right]
        rfl)
      _ _ ?_
    intro b
    cases b
    · -- on `D(g|_V)`
      show M.presheaf.map (homOfLE hB1A).op
          (M.presheaf.map (homOfLE (inf_le_left : (S ⊔ V.1) ⊓ X.basicOpen g ≤ S ⊔ V.1)).op x')
        = M.presheaf.map (homOfLE hB1A).op
          (X.presheaf.map (homOfLE ((inf_le_left : (S ⊔ V.1) ⊓ X.basicOpen g ≤ S ⊔ V.1).trans
            hUW)).op g ^ (n + m) • y)
      rw [res_res M (inf_le_left : (S ⊔ V.1) ⊓ X.basicOpen g ≤ S ⊔ V.1) hB1A
          ((X.basicOpen_le gV).trans le_sup_right),
        ← res_res M (le_sup_right : V.1 ≤ S ⊔ V.1) (X.basicOpen_le gV)
          ((X.basicOpen_le gV).trans le_sup_right)]
      rw [show M.presheaf.map (homOfLE (le_sup_right : V.1 ≤ S ⊔ V.1)).op x'
        = gV ^ m • xV' from hxV'']
      rw [map_smul, map_pow, hres, hV', ← mul_smul, ← pow_add, map_smul, map_pow,
        resRing_res ((inf_le_left : (S ⊔ V.1) ⊓ X.basicOpen g ≤ S ⊔ V.1).trans hUW) hB1A
          hB1W g, ← hyV, Nat.add_comm m n]
    · -- on `S ⊓ D(g)`
      show M.presheaf.map (homOfLE (inf_le_inf le_sup_left le_rfl :
            S ⊓ X.basicOpen g ≤ (S ⊔ V.1) ⊓ X.basicOpen g)).op
          (M.presheaf.map (homOfLE (inf_le_left : (S ⊔ V.1) ⊓ X.basicOpen g ≤ S ⊔ V.1)).op x')
        = M.presheaf.map (homOfLE (inf_le_inf le_sup_left le_rfl)).op
          (X.presheaf.map (homOfLE ((inf_le_left : (S ⊔ V.1) ⊓ X.basicOpen g ≤ S ⊔ V.1).trans
            hUW)).op g ^ (n + m) • y)
      rw [res_res M (inf_le_left : (S ⊔ V.1) ⊓ X.basicOpen g ≤ S ⊔ V.1)
          (inf_le_inf le_sup_left le_rfl) (inf_le_left.trans le_sup_left),
        ← res_res M (le_sup_left : S ≤ S ⊔ V.1)
          (inf_le_left : S ⊓ X.basicOpen g ≤ S) (inf_le_left.trans le_sup_left)]
      rw [show M.presheaf.map (homOfLE (le_sup_left : S ≤ S ⊔ V.1)).op x'
        = X.presheaf.map (homOfLE hSW).op g ^ m • xS' from hxS'']
      rw [map_smul, map_pow,
        resRing_res hSW (inf_le_left : S ⊓ X.basicOpen g ≤ S)
          ((inf_le_left : S ⊓ X.basicOpen g ≤ S).trans hSW) g,
        hS', ← mul_smul, ← pow_add, map_smul, map_pow,
        resRing_res ((inf_le_left : (S ⊔ V.1) ⊓ X.basicOpen g ≤ S ⊔ V.1).trans hUW)
          (inf_le_inf le_sup_left le_rfl)
          ((inf_le_left : S ⊓ X.basicOpen g ≤ S).trans hSW) g, ← hyS, Nat.add_comm m n]