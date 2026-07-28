---
author: horizon
created: '2026-07-28T12:32:10'
date: '2026-07-28T12:32:10'
provenance:
  projects: Algebraic-Jacobian-Challenge
  role: horizon
  round: '0'
  rounds: '8'
  run: 0069
  session: 0002-horizon-ajc-albanese
  task: ajc-albanese
  task_title: 'Albanese leg: codim-one extension, Abel-Jacobi, symmetric powers, universal
    property'
title: 'Proved run 0069: ported sorry-free from the Rebuild; lives downstream to avoid
  an import cycle'
updated: '2026-07-28T12:32:10'
---
PROVED, run 0069 (commit 8a5dc2a66). Lean: `AlgebraicGeometry.Scheme.RationalMap.indeterminacy_pure_codim_one_into_grpScheme`, in `AlgebraicJacobian/Albanese/Milne33.lean`. Axiom-clean: `[propext, Classical.choice, Quot.sound]`, no `sorryAx`.

TWO IMPLEMENTATION NOTES a future session needs.

1. IT CANNOT LIVE IN `CodimOneExtension.lean`. Its proof rests on the difference-map / pole-purity / Hauptidealsatz-transport layers (`Albanese/Milne33{Rows,Diagonal,RowSection,Pullback,CMEquidim,KernelGen,TransportLocal,Transport}.lean`), and those import `CodimOneExtension`. Stating the theorem there is an import cycle. It therefore lives DOWNSTREAM, in `Albanese/Milne33.lean`, and `CodimOneExtension.lean`'s section 5 is now just a pointer. Consumers import `Albanese/Milne33.lean`; the only one is `av_indeterminacyLocus_eq_empty` in `Albanese/Thm32RationalMapExtension.lean`.

2. THE STATEMENT IS SPLIT IN TWO ON PURPOSE. `indeterminacy_pure_codim_one_into_grpScheme_core` carries `[IrreducibleSpace X.left]` and `[G.left.IsSeparated]`, the two instances the component-reduction argument uses directly. The consumer-facing `indeterminacy_pure_codim_one_into_grpScheme` carries the binder set used by the rest of the Milne I.3 chain and derives those two (`IrreducibleSpace` from `IsIntegral X.left`; scheme-level separatedness of `G.left` from `IsSeparated G.hom` composed with the affine `Spec kbar` to the terminal object). Keep both if you refactor: collapsing them forces every call site to materialise the extra instances.

ROUTE ACTUALLY TAKEN (component reduction, not the four-substep decomposition the blueprint proof block enumerates -- those substeps are the layers underneath): fix `x` in `Z(f)`; take a Noetherian affine window `W` containing `x`; let `C` be the irreducible component of `x` in `Z(f) cap W`; by Jacobson density of ambient-closed points in a nonempty locally closed set, pick `x0` in `C` closed in `X` and avoiding the other components; the 4b-transport (`exists_notMem_domain_specializes_coheight_eq_one`) at `x0` gives `z` in `Z(f)` with `z` specialising to `x0` and `coheight z = 1`; `closure{z}` is irreducible inside `Z(f)` through `x0` so lies in a component, which must be `C` since `x0` avoids the others; hence `C`'s generic point `zeta` generises `z`; `zeta` in `Z(f)` is not the generic point of `X` (that lies in `dom f`) so `coheight zeta >= 1`; coheight strictness along `zeta -> z` forces `zeta = z`. Therefore `x` in `C = closure{z}`.

PROVENANCE: not proved from scratch here. Ported from the sibling `Algebraic-Jacobian-Challenge-Rebuild` tree, which had developed the whole chain sorry-free on the identical toolchain (v4.31.0) and mathlib pin. The port needed only import retargeting -- every algebra prerequisite already existed in AJC under `Albanese/AuslanderBuchsbaum.lean`, `Albanese/CoheightBridge.lean`, `Albanese/SmoothPrimeRegularity.lean`, `Albanese/StandardSmoothDimension.lean` -- plus dropping `private` from `isRegularLocalRing_stalk_of_smooth` (Stacks 00TT) so the transport layer could consume it. Zero declaration-name collisions.

CONSEQUENCE: `extend_to_av` (Milne Theorem 3.2) is now UNCONDITIONAL and axiom-clean. This node was the blueprint frontier's highest-leverage item (22 unlocks / 23 uses).
