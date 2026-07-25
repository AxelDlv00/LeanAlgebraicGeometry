# Historical memory index

These iteration-era notes preserve investigation context; file locations and
open-goal claims may now be obsolete. Use `horizon roadmap list --focus
AJC.jacobian` and the project inbox for current status.

- [iter-225 blueprint audit findings](ts225-blueprint-audit.md) — iter-225 whole-blueprint audit: HARD GATE CLEARS for sub-step 4 (`lem:internal_hom_isSheaf` → `AlgebraicGeometry.Scheme.Modules.dual`). Key finding: the sheaf-condition proof is adequate but elides one sentence about sheafification universal property for the descended evaluation. Minor gap, formalizable. `lem:dual_isLocallyTrivial` and `rem:dual_discharges_inverse` coherent with sub-step 4. Dual pin inconsistency between AbelianVarietyRigidity.tex (old `rationalMap_to_av_extends`) and Thm32RationalMapExtension.tex (canonical `Scheme.RationalMap.extend_to_av`) — soon-fix. 6 partial chapters all in held/paused routes.

- [D3′ split landed](d3-split-landed.md) — iter-313: TensorObjSubstrate.lean tail moved to PullbackTensorComp.lean (634L); `key` sorry now at line 502, LSP returns goal without timeout; build GREEN 8627 jobs.
- [Čech leaf-2 reduced to FlatBaseChange frontier](cech-leaf2-reduced-to-flatbasechange.md) — iter-304: leaf-2 plumbing axiom-clean (`mapAlternatingCofaceMapComplexIso` + factoring lemma); file sorry 3→2; whole residual = the cosimplicial iso `e` = FlatBaseChange.lean's still-open pushforward base-change iso. Plus the `.X i` defeq/`erw` trick for alternating-complex `isoOfComponents`.
- [DualInverse naturality wall](dualinverse-naturality-wall.md) — iter-306: 3 naturality sorries need the absent `restrictScalarsLaxε` ε-NatTrans (mathlib has no equivalent); but left_inv/right_inv BYPASS it via `hom_ext` → per-component (closeable with existing ε-cancellation lemmas)
- [Genus split removed → uniform Pic⁰](genus-split-removed-uniform-pic0.md) — 2026-06-23: `genusZeroWitness`/`positiveGenusWitness` collapsed into the uniform `picardJacobianWitness` (`J = Pic⁰`) and most dedicated genus-zero infrastructure was deleted. The dual-purpose `WeilDivisor.lean` still needs the bounded Route-C carve tracked by task `T13` and inbox `I-0106`; retain its codimension-one `PrimeDivisor`/`RationalMap.order` substrate.
