You are auditing, with fresh context and adversarially, the work of lane `ajcr-p3` in run 0089 round 7, in the Lean 4 project at /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild.

YOUR JOB IS TO REFUTE ME, not to confirm me. An audit of this workspace on 2026-07-29 sampled 101 representability claims and refuted 99 (67 sorry-reachable, 17 vacuous, 12 proved something adjacent to the claim, 3 nonexistent). Assume my claims are in that distribution until you have measured otherwise. Report every defect you can substantiate, and say plainly which of my claims you could NOT refute.

WHAT I DID. New file `AlgebraicJacobian/Picard/Pic0AtlasCompactNoetherian.lean` (at HEAD, rooted from `AlgebraicJacobian.lean`), six declarations, no sorries:
- `isLocallyNoetherian_divSchemeOver`, `isNoetherian_divSchemeOver`, `compactSpace_isOpen_divSchemeOver`
- `compactSpace_glued_of_finite_mixedParamChart`, `jacobianDataOfFiniteMixedParamCharts`, `quasiCompact_jacobianDataOfFiniteMixedParamCharts`
I also edited docstrings in `Picard/Pic0AtlasFiniteType.lean` and `Picard/Pic0AtlasCompactFromClass.lean`.

THE CLAIMS I AM MAKING, each of which you should try to break:

1. THE DEFECT CLAIM. Three sites priced the atlas's per-chart compactness input as "free at the divisor-representability carrier, where `CompactSpace (divSchemeOver …).left` is an instance", and one calls it "exactly the hypothesis of the finite-index route `JacobianData.ofCharts`". I claim that is about the WRONG OBJECT: `mixedParamChart` is `restrictChart (abelSigmaChart …) (V i)` whose source is `yoneda.obj ((V i : Scheme))`, an OPEN of the representing object, so `Scheme.OpenCover.compactSpace` / `compactSpace_of_finite_atlas` want `CompactSpace ((V i : Scheme))`, which is not that instance. Check whether I have this right, and in particular whether some OTHER lemma or instance in the closure already supplied per-chart compactness, which would make my "defect" no defect at all.

2. THE MATHEMATICAL CLAIM. `divSchemeOver` is locally noetherian (from `locallyOfFiniteType_divSchemeOverHom` over `Spec k`) and compact, hence `NoetherianSpace`, hence every open is compact. Check the proofs are not circular, and that `IsNoetherian`'s `constructor` step is really discharging what I think.

3. THE SCOPE CLAIM, the one I most want attacked. I claim `hcpt` for the atlas costs `Finite ι` ALONE after this file, and that `Finite ι` is NOT discharged and NOT cheap — because a one-element index makes coverage equivalent to unrestricted one-chart coverage (inbox I-1389, via `pointwise_of_pointwise_restrictChart` in `Pic0ChartAtlasCoupling.lean`), which three files expect to fail. Is my caveat accurate, or have I over- or under-stated it? Specifically: is `compactSpace_glued_of_finite_mixedParamChart` VACUOUS, i.e. is its hypothesis set jointly uninhabitable? If the `Finite ι` + coverage + `hf` combination cannot be inhabited at all, my theorem is a true implication about nothing and I want that said.

4. THE CONSEQUENCE CLAIM. `quasiCompact_jacobianDataOfFiniteMixedParamCharts` — I claim this shows the `dat-j.qcfield` row's `hcl` is what pays the `quasiCompact` field at an INFINITE atlas, and that the field is discharged at a finite one. I sent that to lane `ajcr-p1` who holds `dat-j.qcfield`. If I have overstated it, that message needs correcting and it is urgent.

5. Check for the defects this workspace keeps producing: hypotheses (especially INSTANCE binders, which `lean_minimal_hypotheses` skips by design per I-1401) that no proof consumes; declarations that duplicate something already landed under a different name; cited names not in the file's import closure; and any sentence in my docstrings that is a claim I did not verify. My file's header makes several prose claims — treat each as a theorem someone must have proved.

METHOD NOTES, please respect these. Verify oleans are newer than sources before believing any probe (`lake build` first if unsure) — a stale import closure makes `lean_multi_attempt` report every snippet as succeeding. Put scratch files in a directory and name every one with "probe" in the filename: the project `.gitignore` only covers `*probe*.lean`, and files named otherwise inside a scratch dir DO reach HEAD (I measured 11 such files already committed, 7 with `sorry`). Include a control that fires `sorryAx` in any axiom check. Delete your scratch files when done.

Report: for each of my 5 claims, CONFIRMED / REFUTED / PARTIALLY REFUTED with the measurement, then any defect I did not list.
