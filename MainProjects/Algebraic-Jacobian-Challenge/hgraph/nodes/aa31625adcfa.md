---
author: sync
content_type: theorem
created: '2026-07-28T22:30:24'
decl: AlgebraicGeometry.leakProbe_cechTerm_isQuasicoherent
docstring: "**NON-VACUITY WITNESS** for the two hypothesis-carrying probes above,\
  \ per trap (c)/(d) of the\nworkspace catalogue: a clean axiom line proves nothing\
  \ if the hypotheses cannot be satisfied.\n`leakProbe_qcohRoute_kernel` carries `A.IsQuasicoherent`,\
  \ `B.IsQuasicoherent` as *named*\nhypotheses and `[Flat g]`, `[IsAffine S]`, `[IsAffine\
  \ S']` as instance binders — all four kinds\nthat the catalogue records as invisible\
  \ to `#print axioms`.\n\nSo here the theorem is FIRED, at objects that exist: `A\
  \ = B = M^~` over `S = S' = Spec R` (the\ntilde of any `R`-module is quasi-coherent,\
  \ `AlgebraicGeometry.tilde` instance), with the map the\nidentity and `g` a `Spec`\
  \ of a flat ring map.  If the hypotheses were unsatisfiable — or the\nstatement\
  \ vacuous — this would not elaborate.\n\nNote what this does and does not do: it\
  \ witnesses *satisfiability*, not strength.  The strength\nclaim rests on `leakProbe_qcohRoute_*`\
  \ versus `leakControl_qcohRoute_oldRoute`; `g` being an\nidentity-like `Spec` map\
  \ here would be the wrong argument for *that* comparison (§6b). -/\ntheorem leakWitness_qcohRoute_nonvacuous\
  \ {R R' : CommRingCat.{u}} (φ : R ⟶ R')\n    (hφ : φ.hom.Flat) (M : ModuleCat.{u}\
  \ R) :\n    Limits.PreservesLimit (Limits.parallelPair (\U0001D7D9 (tilde M)) 0)\n\
  \      (Scheme.Modules.pullback (Spec.map φ)) :=\n  haveI : Flat (Spec.map φ) :=\
  \ Flat.SpecMap_iff.mpr hφ\n  leakProbe_qcohRoute_kernel (Spec.map φ) (\U0001D7D9\
  \ (tilde M)) inferInstance inferInstance\n\n#print axioms leakProbe_qcohRoute_kernel\n\
  #print axioms leakProbe_qcohRoute_homologyIso\n#print axioms leakProbe_qcohRoute_coneCancel\n\
  #print axioms leakControl_qcohRoute_oldRoute\n#print axioms leakWitness_qcohRoute_nonvacuous\n\
  \n/-! ### §6d. FLAT BASE CHANGE ITSELF — the declaration the task is about\n\nEverything\
  \ in §6c measures *ingredients*.  Until now **nothing in this file measured\n`cech_flatBaseChange`**,\
  \ which is the theorem the whole `AJC.fbc` lane exists to prove — so the\nlane's\
  \ axiom claims were being read off its inputs.  Fix that: the three declarations\
  \ below are\nthe endpoint, its hypothesis-free form, and the two structural lemmas\
  \ that removed the\ncosimplicial naturality obligation.\n\nRead the group as follows.\n\
  \n* `leakEndpoint_cech_flatBaseChange` and `leakEndpoint_cech_flatBaseChange_qcoh`\
  \ are both\n  expected to report `sorryAx`, and for a **single** reason: `cechComplex_baseChange_iso`\
  \ carries\n  the two cosimplicial naturality `sorry`s of `cech_pushforward_baseChange_natIso`\
  \ and\n  `twisted_cech_nerve_iso`.  That is now the *only* obstruction — the `_qcoh`\
  \ form no longer\n  routes through flat exactness and no longer carries the `h₂`/`h₃`\
  \ quasi-coherence hypotheses.\n* `leakProbe_cechTerm_isQuasicoherent` is the discharge\
  \ of those hypotheses and must be **clean**.\n  If it ever reports `sorryAx`, `cech_flatBaseChange_qcoh`\
  \ has silently regressed to depending on\n  something unproved *besides* naturality.\n\
  * `leakProbe_whiskeredBC_natIso` is the structural half: the cosimplicial natural\
  \ isomorphism\n  built by whiskering the outer mate.  It must be **clean**, and\
  \ its cleanliness is the content\n  of the claim \"naturality is not an obligation\"\
  \ — it constructs, from a degreewise `IsIso` alone,\n  the object that `NatIso.ofComponents`\
  \ could only produce with a naturality proof.\n* `leakProbe_isIso_app_pi` is the\
  \ reduction of that degreewise `IsIso` to one per index tuple.\n  Clean, and pure\
  \ category theory.\n\nSo the honest summary of the lane is readable off four lines:\
  \ the two endpoints dirty, the four\nsupporting reductions clean, and the delta\
  \ between them is exactly the per-σ Beck–Chevalley\ncomparison."
file: scripts/axiom-frontier.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.leakProbe_cechTerm_isQuasicoherent
type: lean
updated: '2026-07-28T22:57:24'
---
theorem leakProbe_cechTerm_isQuasicoherent {S X : Scheme.{u}} (f : X ⟶ S) [IsSeparated f]
    [IsAffine S] (𝒰 : X.OpenCover) [Finite 𝒰.I₀] [∀ i, IsAffine (𝒰.X i)]
    (F : X.Modules) (hF : F.IsQuasicoherent) (p : ℕ) :
    ((CechComplex f 𝒰 F).X p).IsQuasicoherent :=
  isQuasicoherent_cechComplex_X f 𝒰 (fun σ => coverInterOpen_isAffine f 𝒰 σ) F hF p