# The critical path to `Challenge.lean:99`, stated once, with evidence

*Written 2026-07-26 (run 0048 round 4). Every `file:line` below was opened and read during
this pass; nothing here is quoted from a docstring, a roadmap row, or a worksheet without
being checked against the source. That caveat is not decoration — the two standing rules of
this project are that module docstrings announce theorems the files do not declare (I-0349)
and that roadmap summaries are confident and frequently wrong about the Lean
(the `ajcr-roadmap-claims-untrustworthy` memory). Both bit again this round.*

The point of this document is to replace "six independent mountains" with a single ordered
chain, so that a session can see at a glance which link it is standing on. The chain is
written **backwards from the target**, because that is the only direction in which the
dependencies are actually forced.

## 0. The target, and what is admissible

```lean
noncomputable def Jacobian (C : Over (Spec (.of k))) [IsProper C.hom]
    [SmoothOfRelativeDimension 1 C.hom] [GeometricallyIrreducible C.hom] :
    Over (Spec (.of k)) :=
  sorry                                              -- Challenge.lean:96-99
```

`archon-protected.yaml` freezes this signature. No hypothesis may be added, so a conditional
restatement is not a discharge. The sanctioned discharge is `Jacobian C := (jacobianData C).J`,
and `instGrpObj := (jacobianData C).grpObj`, both definitional.

`Challenge.lean` holds 15 `sorry`s. The rest of the tree holds exactly one
(`Picard/Pic0ThetaCocycle.lean:268`) — but see §5: that number is not the reassurance it looks
like.

## 1. The chain, backwards

Each link names the Lean object that has to exist. `LANDED` means a sorry-free declaration that
the configured build kernel-checks. `UNROOTED` means the declaration exists in source but
`lake build AlgebraicJacobian` never sees it (§5). `MISSING` means no declaration.

| # | link | Lean | status |
|---|---|---|---|
| L1 | `Jacobian C := (jacobianData C).J` | `Challenge.lean:99` | MISSING (the target) |
| L2 | the producer `jacobianData C : JacobianData C` | — | **MISSING**, no producer anywhere |
| L3 | the receptacle `structure JacobianData` and its consumer API | `Picard/JacobianData.lean:87-144` | LANDED |
| L4 | `rep : ((pic0Functor C ⋙ forget₂ ⋙ forget).RepresentableBy J` | `JacobianData.lean:93` | field of L3 |
| L5 | descent of the representation from a separably closed stage to `k` | roadmap `dat-g`, `dat-glue` DAT-G0 | MISSING |
| L6 | `pic0RepresentableByOfCharts` — the 01JJ seam | `Picard/Pic0SigmaSheaf.lean:161-169` | **LANDED** |
| L7 | its input (a): a chart family `f`, `hf` of relatively representable open immersions | roadmap `dat-c` C9b | MISSING |
| L8 | its input (b): `Presheaf.IsLocallySurjective … (Sigma.desc f)` | roadmap `dat-b` B-6 | MISSING |
| L9 | what L7/L8 are built from: `(divFunctor C pi g).RepresentableBy DivOver` | `Picard/DivRepKit.lean:114` `representableBy` | UNROOTED |
| L10 | its input: a term of `DivRepGlobalData` | `Picard/DivRepKit.lean:69` | **MISSING — zero producers** |
| L11 | the affine→general lift `DivRepGlobalData.ofAffine` | — | **MISSING, never attempted** (§3) |
| L12 | the affine package `DivRepAffinePullback` | `Picard/DivRepAffKit.lean:167` | structure LANDED, no producer |
| L13 | its `pull` / `isDivRepClassify_pull` fields | — | MISSING, this is **U2** |
| L14 | U2's gate: a certificate for the universal chart family | roadmap `ddr.certificate` | **BLOCKED** (§2) |

L6 deserves emphasis, because the roadmap has never said it plainly: **the hardest-sounding
step, "glue local representability into a scheme", is already done.** `pic0RepresentableByOfCharts`
consumes mathlib's 01JJ engine and returns exactly the type of `JacobianData.rep`. Everything
above it in the table is assembly; everything below it is the real work.

The two genuinely new pieces of mathematics on the chain are **L11** (which nobody had noticed
was missing) and **L14** (which is blocked, and may be blocked for good).

## 2. L14: why the certificate is blocked, and what is genuinely still open

The certificate route asks a relative divisor to be *confined to one of two pinned charts* of
`P^1`. It cannot be, in general:

* `FinCoverData` types its pieces INTO the two pinned charts by construction —
  `h0 : Fin m0 → Γ(relCurve, V0)` (`Picard/DivisorFamily.lean:166`), `h1` into `V1` (`:168`),
  `pieces := Sum.elim (basicOpen ∘ h0) (basicOpen ∘ h1)` (`:186`).
* clause (c1)-finiteness *is* leak-freeness, so every piece trace is clopen in the support
  (`Picard/DivSchemeCertZarConn.lean:98`), and a connected support therefore lands in one piece,
  hence one chart: `supportLocus_subset_chart_of_isCertified`
  (`Picard/DivSchemeCertZarC1.lean:131`).
* the obstruction is `DivEq`-invariant (`DivSchemeCertZarConfine.lean:110`) and survives base
  shrink (`DivSchemeCertZarTransport.lean`), so it bites the quotient `DivFamZar`, not merely a
  representative.

Consequences that are settled and should not be re-litigated:

* Refining the cover, shrinking the base, choosing a cleverer submodule `L`, re-spelling the
  equations, and relaxing the chart-wise partitions to a joint covering are **all provably
  useless**. The sharp form: no repair that keeps the pieces inside the preimages of a FIXED PAIR
  of points of `P^1` can work.
* **Re-basing on the Zariski-local certificate does not help either.** This was worth checking
  and was checked this round. The ε-identity really does consume `IsCertified` through only three
  Zariski-local projections — `divisorWindow_eq_of_le_of_isCertified`
  (`Picard/DivSchemeEps.lean:196`) calls `divisorWindow_eq_of_le` (`:170`), whose hypotheses are
  just `Module.Finite`, `Module.Projective`, constant `rankAtStalk` of `A.ThetaGlued`, plus
  surjectivity of `thetaGluedEval` — and it *can* be re-proved from `IsLocallyCertified` by a
  squeeze over `Localization.Away`, with no `ThetaGlued` base change. But the no-go is about
  **producing** a certificate, not consuming one, and `IsLocallyCertified` fails for exactly the
  divisors `IsCertified` fails for. `DivSchemeCertZarC1.lean:30-31` says so verbatim: `DivFamZar`
  is blind to connected divisors meeting both `pi⁻¹(0)` and `pi⁻¹(∞)`, over any base, after any
  Zariski shrink, for any adaptation.

What remains open, and it is the one cheap decisive experiment:

> The no-go's argument is degree-agnostic, but the only witness ever exhibited
> (`F = tX² + XY + tY²` over `k[t]`, `C = P¹`, `pi = id`) has degree 2 on a curve of genus 0,
> and the functor pins the degree to the genus. At `g = 0` the no-go is vacuous; at `g = 1` base
> shrink evades it. **At `g ≥ 2` no witness has ever been exhibited.**

Either a `g ≥ 2` witness exists — and then the certificate route as designed is dead over an
arbitrary field, and the campaign must pick exactly one of R1 (vary the pinned pair; needs
`Aut(P^1)`, roadmap leaf `p1-aut`), R2 (generalise `FinCoverData`'s piece type), or descent from a
large field (roadmap leaf `dat-g`) — or no witness exists, and the certificate route reopens and
several roadmap leaves are deleted. It is not acceptable to keep planning without knowing which.

A further constraint on R1 that is not optional: the pointwise certificate gate needs two
`κ(p)`-rational points of `P^1` off the fibre's support image at every prime `p`. Over a small
finite residue field, `|P^1(κ(p))| = q + 1` can be smaller than the degree plus two. Since
`Challenge.lean` states the Jacobian over an ARBITRARY field, R1 alone cannot suffice; it needs
the descent lane behind it. That is inbox I-0346's question, and it is the same obstruction seen
pointwise rather than a separate one.

## 3. L11: the link nobody had noticed

`Picard/DivRepKit.lean:69` declares `DivRepGlobalData`, and `:114`
`DivRepGlobalData.representableBy` turns one into
`(divFunctor C pi g).RepresentableBy DivOver` — the divisor-representability endpoint that every
downstream node waits on. **`DivRepGlobalData` occurs in no other file in the tree.** Its own
docstring (`:16-20`) is explicit that this is deliberate: *"The affine-to-general lift is
intentionally not assumed to exist implicitly: a caller must provide every field."*

So between the affine package and the endpoint there is an entire sheaf-theoretic descent step
that appears in no roadmap row and no worksheet task list, because every plan folded it into
"divrep" as bookkeeping. It is not bookkeeping: it glues sections one way and morphisms of
schemes the other.

It is also the best available work that does not touch the blocked mountain, because its main
input is already proved: `Picard/DivisorFamilyZarSheaf.lean` establishes that `divFamZar` is a
Zariski sheaf on *arbitrary* tests — separation `ext_of_le_cover` (`:66`), gluing
`existsUnique_glue_of_le_cover` (`:237`), with the `LocalData` / `IsGlueValue` / `glueValue` /
`glueSection` apparatus at `:92-:226`. Roadmap leaf `…ddr.divrep.lift`.

## 4. What "conditional" buys, and why it is the right shape for this campaign

Links L5, L7, L8, L11 are all *conditional* statements: each can be proved today over a section
variable, without waiting for L14. The idiom is already in the tree — `DivRepGlobalData` itself is
a section variable, and `Picard/DivRepKit.lean` is written entirely against it.

That suggests the shape the roadmap should have, and does not yet: **one open problem (L14), and a
tail that can be closed completely and independently.** A campaign that proves the tail knows
exactly what it is buying with the mountain; a campaign that keeps attacking the mountain first has
now spent seven sessions to learn that three of its repairs are provably useless.

## 5. The number of `sorry`s is not the measure of what is verified

`lake build AlgebraicJacobian` only kernel-checks what is reachable from the root aggregator.
Computing the import closure over `AlgebraicJacobian.lean`:

```
modules on disk .................. 619
reachable from the root .......... 526
UNROOTED ......................... 93   (20,302 lines, ~12 % of the tree)
```

Unrooted families: `DivSchemeHighWindow*` (38), `DivSchemeRedesign*` (28),
`DivSchemeSeedUnivPointwise*` (7), and ten individually-named modules including
`Picard/DivRepKit.lean` itself — so **L9, the endpoint, has never been machine-checked** — as well
as `Picard/EntryIdeal.lean` (634 L), `Picard/DivSchemeWindowMulGeneral.lean` (361 L) and
`Picard/Pic0ThetaCocycle.lean` (272 L).

Two concrete consequences already observed:

* `Picard/DivRepAffKitZar.lean` (174 L, in HEAD) already performs the interface weakening that the
  `u2` roadmap row calls "the cheap edit nobody has made". It is unrooted, so nobody had seen it
  and the row asserted its absence.
* `Pic0ThetaCocycle.lean` cannot be elaborated at all: measured this round at >34 GB RSS after five
  minutes, still climbing, with warm imports (inbox I-0359). Its `:268` `sorry` — the tree's only
  `sorry` outside `Challenge.lean` — sits in a module nothing has ever checked.

Roadmap row `AJCR.w4-rep.build-reach` owns this.

## 6. Reading order for the next session

1. This file.
2. `AJCR.w4-rep`'s roadmap summary, then the leaf you intend to work.
3. The inbox memories on what has been refuted: the Zariski-local re-basing, the joint-covering
   relaxation, the docstring rule, and I-0356 on the off-stratum counterexample.
4. Only then the worksheets (`spec-dd-r.md`, `w4-ddr9-worksheet.md`), which are long, pinned to an
   older route, and contain stale blockers that have been struck in the roadmap but not in the file.
