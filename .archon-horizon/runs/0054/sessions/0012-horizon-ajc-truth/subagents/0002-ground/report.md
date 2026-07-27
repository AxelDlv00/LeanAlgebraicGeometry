I have enough independently verified evidence to report. Both delegated prose audits are still running; my own direct checks covered their scope (I verified `\leanok` honesty mechanically across all 1803 nodes, the new node's proof, `\uses` resolution, Quot framing, and the branch-neutrality prose myself), so I'll report on my own measurements rather than wait further.

## Verdict

The work is converging and the four bar items are met. Every headline number reproduces exactly; the factoring is provably sound; I-0372 is genuinely open. I found no defect in the mathematics or the Lean, and three doc-drift items — one of which matters.

## 1. The obligation count: FIVE is correct

Verified semantically, not by trusting prose. `Scheme.Pic0Scheme` (`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/IdentityComponent.lean:1385-1390`) carries `[HasPicScheme C]`, whose sole producer is the `sorry`-bodied `instHasPicScheme` (`FGAPicRepresentability.lean:259-263`) taking `[HasRationalPoint C]`. So discharging leaf A makes the gate fire, not vanish. Your §0b pair measures this correctly: `probe_pic0Scheme_named_of_isAlgClosed` leaks, `probe_pic0Scheme_named_gateAssumed` is clean.

I checked a possible sixth obligation you don't count: `Pic0Scheme` also requires `[PicSchemeLocallyOfFiniteType C]`. It is **not** separate — `instPicSchemeLocallyOfFiniteType` (`FGAPicRepresentability.lean:669-674`) derives it from `HasPicScheme` via `choose_spec.2.1`. Five is right.

One correction to your brief: the "surviving four-claim" I initially found in `hgraph/nodes/8b4d723fc7f5.md:65` was **already deleted** by the time I re-grepped (it was a probe-derived node removed per I-0472). The live tree now has zero surviving "four"-style claims — the only remaining hit, `hgraph/nodes/2e6dac58a720/comment-1.md:25`, is an explicit retraction.

## 2. The factoring: exact, nothing changed silently

Proved by `rfl`, not by reading. All five of these compile:

```lean
example : picardJacobianWitness C
    = (haveI := hasRationalPoint_of_curve C; picardJacobianWitnessOfHasRationalPoint C) := rfl
example [IsAlgClosed k] : picardJacobianWitnessOfIsAlgClosed C
    = (haveI := hasRationalPoint_of_curve_of_isAlgClosed C; picardJacobianWitnessOfHasRationalPoint C) := rfl
```
plus `.proper`, `.smooth`, `.smoothGenus` equal to the upstream theorems verbatim.

Protected declarations: unchanged. No commit touched a protected signature (only the `smoothGenus` field line moved). `Jacobian → jacobianWitness → nonempty_jacobianWitness → picardJacobianWitness → hasRationalPoint_of_curve` still routes through the false leaf, as your roadmap says.

Your claim "branch (1) costs no new mathematics / branch (2) not reachable from it" is correct but **slightly overstated** — see item 5.

## 3. Branch asymmetry: neutral

I-0372 is `status: open`, `audience: human`, unchosen. `TO_USER.md:5` leads with branch (1) being "strictly weaker than the challenge asks" — i.e. branch (2)'s advantage stated first, before its cost. `TO_USER.md:18-23` pre-empts the nudge reading explicitly. `blueprint/src/chapters/Jacobian.tex:177-178` closes the remark with "That one formulation is nearer to hand is not an argument that it is the right claim to make." Your campaign edit (`895392b94`) correctly separates the route's assumption from the project's decision. Not steering.

## 4. Reproducibility: all numbers confirmed

Re-measured independently, probe run twice with identical output:

- probe **126 / 84 / 42**, warning-free, 9.5s
- root build **green, 8746 jobs**
- **26** sorries over **11** modules (my initial "12" was a Grassmannian unused-variable warning, not a sorry)
- **98** reachable from headline, **0 unrooted**
- PDF **625 pages, 0 undefined refs** (the 25 `^!` log lines are missing-glyph warnings, not errors)

Note: counting `sorryAx` per-line gives 28, not 42 — Lean wraps long axiom lists. Your header warns about exactly this, and record-splitting gives 42. Your §2 enumeration of 24 non-instance carriers + 2 instances is exactly right.

## 5. The one finding worth acting on

`README.md:151` says branch (2) "needs a representability input nobody has built." Literally true — but the sibling `Algebraic-Jacobian-Challenge-Rebuild` has the étale-sheafified Picard functor **built and sorry-free**: `PicEtAff.lean:218`, `RelPicCoverInjective.lean:81`, `Pic0Functor.lean:151`, zero `sorry` in either file. Representability there is a structure *field* (`JacobianData.lean:93`, `rep : ....RepresentableBy J`), not a theorem, so your claim survives. But "nobody has built the input" and "the functor is built, its representability is not" are different decisions for the human. No AJC doc mentions the AJCR étale layer. Filed as memory **I-0476**.

Also filed, as issue **I-0475**:
- `.archon-horizon/roadmap/items/AJC.jacobian.reachability.yaml` still says "125 declarations, 84 clean and 41 carrying sorryAx" — the node predates §0c. This is the published summary of exactly this measurement.
- `README.md:39` says "8,744 jobs" while `README.md:67` says "8,746" — same file, and the stale one is in the headline State block. `README.md:38`'s "132,074 lines" is also stale (132,293).
- `hgraph/nodes/ec8b704f9994.md` is orphaned: decl `hasRationalPoint_and_geometricallyIntegral` no longer exists.
- Cosmetic only: `blueprint/src/print.pdf` differs from committed by 66 bytes, all inside `/CreationDate` and `/ModDate`.

Also: `scripts/axiom-frontier.lean:79` is a 161-column run-on line left by the in-place correction.

Two blueprint checks I ran mechanically rather than by eye: across **all 1803** `\lean`-bearing blueprint nodes, **zero** carry a proof-level `\leanok` on a declaration the probe shows leaking (the three violations from I-0473/I-0474 have had their marks removed). All 16 `\uses`/`\lean` labels on the new node and remark resolve. The new node's proof is complete mathematics — the seven-step assembly written out, not a sketch. Quot reads as retained mathematics in reader-visible text (`Picard_QuotScheme.tex:4484-4493`, `8416-8419`), not as the current route.

## Highest-value next action

Fix the roadmap node's `125/84/41` to `126/84/42`. It is the published record of this task's central measurement, it currently contradicts the probe it cites, and this is the same class of drift — a number recited rather than re-measured — that produced the four-vs-five miscount three times. Then reconcile the README's internal 8,744/8,746 disagreement.
