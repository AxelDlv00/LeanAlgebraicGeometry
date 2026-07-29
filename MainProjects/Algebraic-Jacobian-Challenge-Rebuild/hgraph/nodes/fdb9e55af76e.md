---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.divFamEps
docstring: '**The embedding `ε` of the divisor functor, submodule form** (worksheet
  §2.3 step 3,

  Task 5): a certified divisor family of degree `g` over `R` is sent to its pair of
  window

  submodules `(K_M(d), K_{M+s}(d))` inside the free windows `R ⊗[k] H_M`, `R ⊗[k]
  H_{M+s}`

  at the DD-0 ledger exponents.  Well defined on the setoid quotient by

  `divisorWindow_eq_of_divEq`.  The Grassmannian-pair membership of the components
  — the

  corank-`g` certificates — is Task 4''s remaining heart (`divisorWindowGr`); mono-ness
  and

  naturality are Tasks 6/7.'
file: AlgebraicJacobian/Picard/DivisorFamilyWindow.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divFamEps
type: lean
updated: '2026-07-29T15:31:45'
---
noncomputable def divFamEps (g : ℕ) (F : DivFam C R π g) :
    Submodule R (R ⊗[k]
        ↥(Scheme.divisorSections k (windowM_choice π hπ g • fiberWeilDivisor π) ⊤))
      × Submodule R (R ⊗[k] ↥(Scheme.divisorSections k
          ((windowM_choice π hπ g + windowS_choice π hπ g) • fiberWeilDivisor π) ⊤)) :=
  (F.window (relThetaPairH1_windowM C π hπ g),
   F.window (relThetaPairH1_windowMS C π hπ g))

@[simp]