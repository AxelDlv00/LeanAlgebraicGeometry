# Iter-025 objectives

## Lane 1 (only) — `AlgebraicJacobian/Cohomology/CechBridge.lean` [mathlib-build]
Build `AlgebraicGeometry.injective_cech_acyclic` (`lem:injective_cech_acyclic`, Stacks
`lemma-injective-trivial-cech`): positive-degree vanishing of the section Čech cohomology of an injective
`O_X`-module `I`. The decl does not exist yet → scaffold a faithful signature + build.

Route (every ingredient `\leanok`, op-transport assembly):
- Part 1 (PresheafCech, done): `injective_toPresheafOfModules` — injective sheaf ⟹ injective presheaf via
  `Injective.injective_of_adjoint` + `sheafificationAdjunction`.
- Part 2 (assembly): `(cechFreeComplexAug 𝒰).op` ▸ `preadditiveYoneda.obj I` stays quasi-iso
  (`quasiIso_map_preadditiveYoneda_of_injective`); transport across `homCechComplexMapOpIso` +
  `sectionCechComplexMapOpIso` ⇒ section Čech complex of `I` has vanishing positive homology, `Ȟ⁰=I(U)`.

Also: fix the 2 stale CechBridge module docstrings (`ses_cech_h1` "(planned)", `injective_cech_acyclic`
"gated on Lane-1" — both now false).

Blueprint: `chapters/Cohomology_CechHigherDirectImage.tex`, `lem:injective_cech_acyclic` (~L2562) + its
8 `\uses` deps. Analogy for the op-bridge mechanics: prior CechBridge task results.

## Plan-phase subagent outputs (this iter)
- `blueprint-writer/coverage-025` — coverage debt 32→0 (helpers bundled into `\lean{}` lists).
- `mathlib-analogist/abscohom-025` — absolute `Hⁿ(U,F)`:=Ext decision (`analogies/absolute-cohomology.md`).
- `blueprint-writer/extcohom-025` — `def:absolute_cohomology` + 6 `\mathlibok` Ext anchors; 01EO/02KG rewired.
- `blueprint-reviewer/iter025` — HARD GATE CLEARS `injective_cech_acyclic`; `\restriction` macro fixed.

## Skips
- progress-critic, strategy-critic — see `plan.md` `## Subagent skips`.
