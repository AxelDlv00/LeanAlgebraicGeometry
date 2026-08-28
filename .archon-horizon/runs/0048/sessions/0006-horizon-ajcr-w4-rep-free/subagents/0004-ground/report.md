## Verdict

**Circling — and now circling in a way that looks like progress, which is worse.** Round 2 landed ~700 lines of rooted, axiom-clean, kernel-checked Lean (I verified the oleans and the root `AlgebraicJacobian.olean` at 00:31, after all five module oleans — the build claims are honest). But the number of gates closed toward `Challenge.lean:99` is zero, same as run 0047 rounds 1–5. The decisive evidence is not the line count: it is that **this lane has now spent two rounds re-costing gates without checking whether the gates are still real, and the flagship one is not.** The `u2` row and the worksheet both say U2 is "gated on the I-0234 windowS strengthening (b+2g → b+3g) and its full-rebuild window." That strengthening is **already landed** — `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/WindowLedger.lean:139` defines `windowS_exists` with `windowBound π hπ + 3 * (g : ℤ)`, `:157` proves `windowS_spec_three`, and `:164` keeps the old `b+2g` form only for byte-compatibility. I-0234 is archived because it was done. The lane has been treating a discharged blocker as live.

That said: the *diagnosis* round 2 produced — the top of the mountain is thin, the deepest foothill is over-invested — is correct, and is the round's genuine deliverable. The three commits that acted on it are not.

---

## 1. Is "spread across mountains" the right strategy?

**No. It is drift.** Three ~100-line additions on three mountains, none of which moved a gate:

- `eq_of_isDivRepClassify` (`.../Picard/DivRepClassifyZarSep.lean:352`) is real, substantial mathematics (the `mapAlg_eq_of_certChartFrames` core at `:185` is 150 lines of honest work, and `divFam_divEq_of_eps_eq_total` at `.../Picard/DivSchemeMonoBridgeRel.lean:417` genuinely is seam-free). But it quantifies over `DivFamZar`, whose membership predicate **is** `IsLocallyCertified` (`.../Picard/DivisorFamilyZar.lean:71`, `:235`) — the object round 1 declared wrong. Worse, its load-bearing input `DivFamZar.exists_certChartCover` (`.../Picard/DivRepClassifyZarKit.lean:433`) is **explicitly named in `cert-relocalize`'s own declared blast radius**. If R1 lands, this theorem needs re-proving, and it will break at the "both presentations give the same morphism to `grPair`" step, because `v`'s type is π-pinned: `DivScheme k (windowS_choice π hπ g • fiberWeilDivisor π) …`. The roadmap records the blast radius on one leaf and the triumph on another and never connects them.
- `chartLocus` — see I-0351 (filed concurrently); 30 lines composing two landed layers, under a co-signed name reserved for a bigger assembly.
- `JacobianDataAbel.lean` — 88 lines, contingent on a discharge nobody has committed to (I-0353).

"Spread across mountains" would be right if each probe had been a *cheap test of whether a gate is real*. Instead each was a *deliverable on a mountain whose gate was never re-tested*. The probe that would have paid — one grep of `WindowLedger.lean` — was not run.

## 2. The true last link

**The roadmap's ordering is wrong, and `dat-j` is not the constraint.** `dat-j` is last in dependency order but it is packaging. The constraint is a single object with **no roadmap leaf at all**:

```
U1 : divUniversalFamily i j : CertifiedDivisorFamily C R_Z π g
```

Its collapse makes `divrep`, `ddq`, `dat-c.c9b`, `dat-b` B-6, `dat-glue` and `dat-j` all cheap simultaneously. Its state is far better than the roadmap says, and its dependency is misdescribed:

- `seedUniv : ThetaGeneratorSeed` over `R_Z` **exists** — `.../Picard/DivSchemeSeedUnivGen.lean:283`.
- The fibrewise keystone **exists and is proved** — `existsUnique_effective_divisor_divUniversalFibre` (`.../Picard/DivSchemeSeedUnivAssembleKappa.lean:417`) and `…_residueField` (`:481`): at every prime of the pair chart ring over the carve ideal, a *unique* effective degree-`g` divisor cuts both universal windows.
- What is missing is `ThetaGeneratorSeed.certifiedFamily` (`.../Picard/DivSchemeEps.lean:237`), which demands `(D.divisorAdaptation hD).IsCertified g` — **a global certificate over `R_Z`**.

So `ddr.divrep` is **not** an independent mountain from `ddr.certificate`. The master summary's "SIX INDEPENDENT MOUNTAINS" hides the one edge that matters. This also refutes I-0320's headline ("no consumer ever needed `IsCertified` over R"): `divRepPullAt` (`.../Picard/DivRepAffKit.lean:90`) takes `U i j : CertifiedDivisorFamily C (ChartRing i j) π g`.

**Cheap edit nobody has made:** `divRepPullAt`'s body is `DivFamZar.mapAlgHom omega (DivFam.mk (U i j)).toZar` — it only ever uses the `toZar` image. Retype `U : ∀ i j, DivFamZar C (ChartRing i j) π g`. Strictly weaker, `divRepPullAt_id`/`_comp`/`IsCompatible` survive verbatim, and it is what makes I-0320's relaxation actually reach U1.

## 3. The U2 question

**The gate is real as mathematics and stale as stated.** The stated blocker (I-0234 + a rebuild window) is discharged, as above. The remaining content is the G-4 certificate discharge — i.e. mountain 1 again.

**Is there a route to `divRep` with no universal family? No.** By Yoneda, `pull` at a general `S` *is* the universal family at `R_Z`; there is nowhere to hide it. But round 2's own theorem shortens the interface and nobody noticed:

`DivRepChartFamily.IsCompatible` (`.../Picard/DivRepAffKit.lean:127`) — the F5 overlap obligation — carries a docstring saying it is proved "from its epsilon identity **and the total mono theorem**". With `eq_of_isDivRepClassify` the mono leg is gone:

```
IsCompatible U  ⟸  ∀ S i j ω, IsDivRepClassify (divRepPullAt U i j ω) (Spec ω ≫ ChartMap i j)
```

is a five-line corollary (both pulled classes are classified by the same `q`; sep concludes). That collapses the whole F5 overlap obligation into one per-chart clause, which *is* U2. **This is landable today and is the correct top move on the divrep row.**

Correspondingly, **I-0350's #1 ranked move, `pull_naturality`, is ill-posed.** It is a *field* of `DivRepAffinePullback` (`.../Picard/DivRepAffKit.lean:176`) quantified over another field `pull` that has no producer — there is no standalone theorem to prove. Its algebraic content is already landed as `divRepPullAt_comp` (`:111`, docstring: "the algebraic part of F5 naturality").

## 4. The chart-avoid no-go's consequence

**R1 is cheaper, decisively, and the roadmap prices it wrong in the expensive direction.**

- `P1 k := Proj (homogeneousSubmodule (Fin 2) k)` — `.../AlgebraicJacobian/Curve/P1.lean:135`, literally mathlib's `Proj` of the standard grading.
- Mathlib at this rev **ships** `AlgebraicGeometry.Proj.map` (`.lake-packages/mathlib/Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Functor.lean:144`) with `map_comp` (`:204`) and `map_id` (`:211`), for graded ring homs `𝒜 →+*ᵍ ℬ` with `hf : ℬ₊ ≤ 𝒜₊.map f` — trivial for an isomorphism.

So p1-aut obligation (i) is a linear change of variables on `MvPolynomial (Fin 2) k` packaged as a `GradedRingHom`, plus `Proj.map`; obligation (ii) is "two distinct points of P¹(k) lift to a basis of k²". One session, not a campaign. The row's framing as "build the GL₂(k) action and prove transitivity" is what has made it look unaffordable.

R2's price: `FinCoverData` has **215 occurrences across 28 files**, plus `thetaIdealDatum` copying `partition₀`/`partition₁` into `BasicOpenCocycleDatum` (`.../Picard/DivisorThetaDatum.lean:397-401`). Do not attempt it.

**Is there a third option?** I looked for one and I do not think a good one exists, for a reason worth recording: at degree `g` with `h¹ = 0`, Riemann–Roch gives `h⁰ = 1`, so **the effective divisor in the class is rigid** — you cannot move `D` off the two pinned fibres, you can only move the fibres. That is exactly why R1/R2 exhaust the space. The one genuinely untried variant is **raise the degree**: `divFunctor C π n` (`.../Picard/DivisorFamilyZarFunctor.lean:45`) is generic in `n`, and at `d ≥ 2g+1` the linear system moves. It fails anyway, and for the same reason as everything else — over 𝔽_q you cannot rationally choose a member avoiding ~2·deg π points once q is small — and it would cost re-deriving the window ledger, since `hχ : Sheaf.chi = 1 - g` pins degree to genus at the divRep layer (`.../Picard/DivRepClassifyZarSep.lean:147`). Not worth it.

**And the divisor functor is the right intermediate object.** Wave 6's reachability-from-the-top says nothing about this: `pic0RepresentableByOfCharts` (`.../Picard/Pic0SigmaSheaf.lean:161`) consumes chart morphisms `f_c`, and `f_c` needs the universal family. There is no chart-free route to Pic⁰ in this design.

**On I-0346 / `field-size` — you are waiting for a decision your own roadmap already answers.** Option (b) is `AJCR.w4-rep.datum.dat-g`, which is titled "finite-Galois/Speiser descent of the datum … from a finite separable stage to the challenge field". Over 𝔽_q, descend from 𝔽_{q^m} with q^m large; the extension is separable, the object is quasi-projective, descent is effective. The lane should stop treating this as a blocker and record (b) as the plan of record. Escalating it a second time burns a round.

## 5. Top-down vs bottom-up: yes, there is much more unclaimed top work

`JacobianData` (`.../Picard/JacobianData.lean:87-100`) carries only `J`, `rep`, `locallyOfFiniteType`, `quasiCompact`. Mapping the 15 frozen `Challenge.lean` sorries against landed avatars:

| Frozen gate | Avatar |
|---|---|
| `:108` `instGrpObj` | `JacobianData.grpObj` `.../Picard/JacobianData.lean:113` ✓ |
| `:126` `ofCurve`, `:134` `comp_ofCurve` | new this round ✓ |
| `:156-158` `functor` map/id/comp | `pullbackHom` / `_id` / `_comp` — `.../Picard/Pic0PullbackGrp.lean:77, :105, :127` ✓ **(pre-existing)** |
| `:248` `baseChangeIso` | `baseChangeIsoOfData` `.../Picard/JacobianDataBaseChange.lean:227` ✓ **(pre-existing)** |
| `:283` `baseChange_ofCurve` | `baseChange_ofCurve_data_of_core` `.../Picard/JacobianDataBaseChangeAbel.lean:143` ✓ (modulo `hCore`) |
| `:113` `SmoothOfRelativeDimension (genus C)` | **none** |
| `:117` `IsProper` | **none** |
| `:121` `GeometricallyIrreducible` | **none** |
| `:147` `exists_unique_ofCurve_comp` | **none** |
| `:259`, `:272` coherences | **none** |

The unclaimed block is **Wave 5**, not Wave 4. `AJCR.w5-av` is pending 8/16 with **eight open leaves that all have empty summaries** — title only:

- `t1` dual-number tangent kit (old-draft port), `t3` `ker(relPic(k[ε]) → relPic(k)) ≅ H¹(C,𝒪)`, `t4` étale-plus/Zariski kernel crossing at `k[ε]`, `t5` `dim_k T₀(d.J) = g`
- `s1` geometric reducedness at the identity (two-term `H² = 0` square-zero lifting), `s2` `Smooth d.J.hom` via `smooth_of_grpObj`, `s3` `SmoothOfRelativeDimension g` assembly
- `p1` (blocked)

`t1`/`t3`/`t4` mention no Jacobian at all — pure deformation theory of `relPic` — and the substrate is landed in `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Tangent/` (`DualNumberBaseChange.lean`, `TruncExpCech.lean`, `TruncExpCechH1.lean`, `TruncExpUnits.lean`; `w5-av.t2` is done). `s2`/`s3`/`t5` are datum-level, hence divRep-free by construction. Also open and divRep-free: `AJCR.w7-functor.a1` (only `hCore`, the shuffle-on-graph identity, remains).

## 6. What in round 2 I judge wrong or overstated

1. **"The top of the mountain, where nobody had worked" (commit `7e5e268a6`) is false.** `AJCR.w7-functor` is 10/12 done and `pullbackHom_id`/`pullbackHom_comp`/`baseChangeIsoOfData` were already datum-level avatars of `Challenge.lean:156-158` and `:248`. The correct claim is narrower: *two Albanese* gates got avatars.
2. **"`ddr.divrep` MOVED for the first time in the campaign" oversells.** The retired obligation (`pull_classify`) was the derivable one; the two that carry 100% of the difficulty (`pull`, `isDivRepClassify_pull`) are untouched. Commit `0b3ab49b8`'s own message says so; the roadmap row does not.
3. **The `u2` row's I-0234 clause is stale** (§3 above). So is `informal/w4-ddr9-worksheet.md:334-338`.
4. **The chart-avoid counterexample is off-stratum.** `F = tX² + XY + tY²` over `k[t]` with `C = P¹, π = id` is degree 2 on a **genus-0** curve. The campaign's functor is `DivFamZar C S π g` with `g` pinned to the genus by `hχ : Sheaf.chi = 1 - g` (`.../Picard/DivRepClassifyZarSep.lean:147`), and `IsCertified n`'s clause (c2) fixes the glued colength's fibre rank to `n = deg D` (`.../Picard/DivisorFamily.lean:426-437`). On-stratum: `g=0` is vacuous (empty support); `g=1` is a section, whose support locus is `Spec R`, so base shrink evades it — and the gate is pointwise on the base after I-0320. The no-go bites at `g ≥ 2` and **no witness has been exhibited there**. The structural argument is degree-agnostic and I believe the conclusion; the record claims more than it has.
5. **"Certificate-free" on `eq_of_isDivRepClassify` is a misleading label** — `DivFamZar`'s membership predicate *is* the certificate, and `exists_certChartCover` is in `cert-relocalize`'s own blast radius. Not wrong, but the roadmap should say it.
6. **Credit where due:** the `build-reach` re-measurement is honest and I verified it independently (oleans present, root olean newest, `Pic0ThetaCocycle` has none). The `joint-cover` rejection is correct and correctly reasoned from typing. `divFam_divEq_of_eps_eq_total` really is seam-free. The adversarial self-correction habit is the healthiest thing in this lane.

## Blueprint / Lean / graph disagreement

`grep` over `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/blueprint/src/chapters/*.tex`:

```
DivFamZar | divFunctor | IsCertified | DivisorAdaptation | CertifiedDivisorFamily | DivRep  ->  0 hits
DivScheme | Grassmannian                                                             ->  0 hits
```

**Zero blueprint coverage of the entire DD-R tower** — 300+ Picard modules and the whole certificate no-go — while `def:pic0RepresentableByOfCharts` (`blueprint/src/chapters/PicardEtale.tex:10677`) reads as one hypothesis away. I-0333 asked for ~5 nodes; nothing was commissioned. The AJCR source tree itself is clean under the ledger; the 200 dirty paths are run 0046's hgraph nodes and workspace state, not this lane's.

## Ranked recommendation for the next session

1. **Land `IsCompatible_of_isDivRepClassify`** — five lines, off `eq_of_isDivRepClassify`, in `.../Picard/DivRepAffKit.lean` or a new file. It collapses the F5 overlap obligation to exactly U2 and retires the "total mono theorem" leg from the F5 interface. This is the highest-value single action available and it is *this round's own theorem finally being used for something*. Do it instead of `pull_naturality`.
2. **Correct the two stale gates in the record before briefing anyone**: delete the I-0234 clause from the `u2` row and the worksheet; add the `U1 ⟵ IsCertified over R_Z` edge to the master summary so `divrep` stops reading as independent of `certificate`. Retype `divRepPullAt`'s `U` to `DivFamZar` while you are there.
3. **`p1-aut`, on mathlib's `Proj.map`.** It is a one-session item, not a campaign, and it unblocks `fibre-avoid → cert-relocalize → swallow-adapt → cert-collapse → cert-assemble` and therefore U1. Record (b)-descent as the answer to `field-size` and stop waiting.
4. **If a second front is wanted, take Wave 5, not Wave 4**: write summaries for `AJCR.w5-av.t1/t3/t4/t5/s1/s2/s3` and launch `t3` (`ker(relPic(k[ε]) → relPic(k)) ≅ H¹(C,𝒪)`), which touches no Jacobian, no certificate, no divRep, and has landed substrate in `AlgebraicJacobian/Tangent/`.
5. **Commission the missing blueprint nodes.** Not a proving task, but the blueprint is currently the workspace's largest false statement about its own state.

## Filed

- **I-0355** (issue) — the divRep gate is mis-stated three ways: I-0234 discharged, U1's substrate landed and certificate-gated, `divRepPullAt` weakenable, `pull_naturality` ill-posed, `IsCompatible` is the real move.
- **I-0356** (issue) — the chart-avoid counterexample is off-stratum (degree 2, genus 0); needs a genus-≥2 witness or an explicit note.
- **I-0357** (memory) — zero blueprint coverage of the DD-R tower; Wave 5's eight unbriefed divRep-free leaves are the largest unclaimed block.

Non-duplicative with the concurrent reviewer's I-0351/0352/0353/0354, which I read first.
