Reconnaissance report:

- Current project has 52 Lean declarations and no source-level `sorry`, `admit`, or `axiom`. Existing modules are `Basic`, `Categories`, `SetTheory`, `Spectrum`, `Topology`, `Zariski`, and `IdealTheory`; a concurrent worker has added an untracked `Localization.lean` and imported it from `Basic.lean`, so avoid overlapping that work.
- Hgraph stats: 5,553 nodes, 5,383 edges; 52 closed Lean nodes, 2,985 ready nodes, 2,516 blocked nodes. All 5,501 TeX nodes currently have empty `lean_status`; chapters 2–5 have no `\lean{}` pins (`ch02`: 0 uses, `ch03`: 12, `ch04`: 135, `ch05`: 108). Blueprint freeze I-2034 applies.

Best new chapter 2–5 targets:

1. `topology-lemma-intersection-closed-in-quasi-compact`  
   Blueprint: [`ch05-topology.tex`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part01_Preliminaries/blueprint/src/ch05-topology.tex:1952), graph id `3b91953d91e6`, 38 unlocks. Statement: for a quasi-compact space and a family of closed sets with every finite intersection nonempty, the total intersection is nonempty. Proof should be a short wrapper around mathlib `CompactSpace.iInter_nonempty` (in `Mathlib/Topology/Instances/Compact.lean`, around line 813), after installing `letI : CompactSpace X := ⟨hX⟩` from the local `QuasiCompactSpace` wrapper and supplying closedness/nonempty hypotheses.

2. `topology-lemma-quasi-compact-in-Hausdorff`  
   Blueprint: [`ch05-topology.tex`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part01_Preliminaries/blueprint/src/ch05-topology.tex:1896), graph id `a791838019cf`, 29 unlocks. It has two clauses: compact subsets of a Hausdorff space are closed, and disjoint compact subsets admit disjoint open neighborhoods. The first is already exactly covered by [`Topology.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/StacksProject/Part01_Preliminaries/StacksPart01Lib/Topology.lean:100) `quasiCompact_isClosed`; the second can be derived from mathlib `SeparatedNhds.of_isCompact_isCompact` (`Mathlib/Topology/Instances/ENNReal`/Hausdorff source around `Hausdorff.lean:547`) by unpacking the separated-neighborhood pair. This is slightly more involved than target 1.

Other highest-frontier, very easy targets (chapter 10, if scope is broadened):

- `algebra-lemma-product-ideals-in-prime`, graph id `effff2d9e600`, 307 unlocks: likely direct `Ideal.IsPrime.mul_le.mp` from `Mathlib/RingTheory/Ideal/Operations.lean` (around line 984), i.e. `(hp.mul_le).mp hIJ`.
- `algebra-lemma-idempotent-spec`, graph id `72671055e791`, 327 unlocks: prove basic opens `D(e)` and `D(1-e)` are disjoint using `x.isPrime.mul_mem_iff_mem_or_mem`, `IsPrime.one_notMem`, and `e * (1-e) = 0` for an idempotent. Existing spectrum/Zariski membership wrappers make this manageable.
- Localization exactness and the universal-property target are already being implemented in the live untracked `StacksPart01Lib/Localization.lean`; do not duplicate.

Recent project commits (newest first): `2cb1acdd66` docstring preservation, `1931797e76` ideal-theory exposure, `483ffb9269` ideal zero-locus laws, `547c29e1d0` Zariski module, `5de07d6132` standard-open identities, `8a5c2603ee` connectedness tags, `8749d1ea20` connectedness closure lemmas, `b268daf9d3` spectrum/topology loci, `5aaa75451f` cofinality lemmas, `432a23719d` compactness closures, followed by blueprint/config bootstrap commits.
