# The critical path to `Challenge.lean:99`, stated once, with evidence

*Written 2026-07-26 (run 0048 round 4). Every `file:line` below was opened and read during
this pass; nothing here is quoted from a docstring, a roadmap row, or a worksheet without
being checked against the source. That caveat is not decoration — the two standing rules of
this project are that module docstrings announce theorems the files do not declare (I-0349)
and that roadmap summaries are confident and frequently wrong about the Lean
(the `ajcr-roadmap-claims-untrustworthy` memory). Both bit again this round.*

> **ROUND-5 AMENDMENT (run 0048 round 5).** The table in §1 was already stale when it was
> committed, and §2's "one open experiment" had been answered the same round by this file's own
> sibling deliverable. Read §7 at the bottom FIRST: it carries the corrections and the current
> state of the chain. The rest of the file is left as written, because the reasoning is still the
> reasoning; only the status column and §2's closing question have moved.

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

1. This file — **§7 first**.
2. `AJCR.w4-rep`'s roadmap summary, then the leaf you intend to work.
3. The inbox memories on what has been refuted: the Zariski-local re-basing, the joint-covering
   relaxation, the docstring rule, and I-0356 on the off-stratum counterexample.
4. Only then the worksheets (`spec-dd-r.md`, `w4-ddr9-worksheet.md`), which are long, pinned to an
   older route, and contain stale blockers that have been struck in the roadmap but not in the file.

## 7. Round-5 corrections, and where the chain actually stands

*Run 0048 round 5. Everything below was checked against the source or landed as Lean this round.*

### 7.1 Four rows of §1's table have moved

| # | §1 said | truth as of round 5 |
|---|---|---|
| L2 | `jacobianData` MISSING, no producer anywhere | **`JacobianData.ofCharts`** (`Picard/JacobianDataCharts.lean:182`) — a conditional producer, sorry-free, rooted, kernel-checked. `JacobianData` had zero producers before this round; it has two now (`ofRepresentableBy` :71 and `ofCharts` :182). |
| L9 | `(divFunctor C π g).RepresentableBy DivOver` exists but **UNROOTED** | **rooted.** `Picard/DivRepGlobalLift.lean` imports `DivRepKit`, and the root aggregator imports `DivRepGlobalLift`. L9 is kernel-checked. |
| L11 | `DivRepGlobalData.ofAffine` **MISSING, never attempted** | its **forward half is landed**: `DivRepAffinePullback.pullGlobal` (`Picard/DivRepGlobalLift.lean:102`) is the `pull` field and `pullGlobal_comp` (:132) is the `pull_comp` field, both from the affine package alone. What is left of L11 is the general-test **classifier** and the two inverse laws. |
| L4 | field of L3 | the two finiteness certificates of L3/L4 are no longer obligations: `locallyOfFiniteType_gluedHom` (:154) and `quasiCompact_gluedHom` (:164) derive them from properties of the charts. |

`DivRepGlobalLift.lean` was written in round 4 but landed only through that round's integration
commit, which is why §1 — written in the same round — did not know about it. Check the ledger for
files added by an `integrate` commit before trusting any "MISSING" claim.

### 7.2 The `GeometricallyReduced` scare, checked and closed

`Picard/Pic0SigmaSheaf.lean:79` declares `variable [GeometricallyReduced C.hom]` before the sheaf
theorem and `pic0RepresentableByOfCharts`, and `Challenge.lean:96-98`'s frozen bundle does not
supply it — so the whole representability seam appeared to demand a hypothesis the target forbids.
It does not. `Curve/GeometricallyReduced.lean:130` gives `Smooth.geometricallyReduced` and `:140`
gives `Smooth.of_smoothOfRelativeDimension_one`, both instances, and that module is in
`Pic0SigmaSheaf`'s import closure. The hypothesis is redundant, not a gap. Machine-checked record:
`Picard/JacobianDataCharts.lean:210`.

### 7.3 §2's "one open experiment" was already answered, by this file's own sibling

§2 closes with *"At `g ≥ 2` no witness has ever been exhibited… It is not acceptable to keep
planning without knowing which."* That question was settled in the **same round**:
`informal/spec-dd-r.md` **ADDENDUM 4** (commit `d7e8348ce`) is titled *"the on-stratum witness
EXISTS"*, and roadmap leaf `…ddr.certificate.field-size` is `done` carrying the sharp theorem.

**The conclusion stands on ADDENDUM 4, not on what follows.** A ground review corrected the
first draft of this subsection, which claimed the argument below "agrees with" ADDENDUM 4 and holds
"over any field". It does neither. ADDENDUM 4 §4.3 uses the universal divisor over `Sym^g C`,
base-changes to an extension and pads by `(g−1)Q₀`, and states at `spec-dd-r.md:826` that no
rational-point hypothesis is used anywhere. What follows is a **different, cheaper witness** — a
pencil rather than `Sym^g` — with a side condition ADDENDUM 4 does not need:

> For any `g ≥ 2`, take a pencil of degree `g` on `C` one of whose members is a divisor
> `E ≥ s₀ + s_∞` with `π(s₀) = 0`, `π(s_∞) = ∞`. Such an `E` exists: `ℓ(E) = 1 + ℓ(K − E)`, so any
> `E` with `s₀ + s_∞ ≤ E ≤ K'` for a canonical `K' ≥ s₀ + s_∞` has `ℓ(E) ≥ 2`; and such a `K'`
> exists because `ℓ(K − s₀ − s_∞) ≥ g − 2 ≥ 1` for `g ≥ 3`, and for `g = 2` exactly when `s_∞` is
> the hyperelliptic conjugate of `s₀` (which one is free to arrange, since `π` is a choice: a
> function with a zero at `s₀` and a pole at `s_∞` is a finite map sending them to `0` and `∞`).
> The support of the total family is an open subscheme of the irreducible `C`, hence irreducible,
> hence **connected after every Zariski shrink of the base** — which is exactly why the shrink
> evasion that kills the `g = 1` case does not apply here.

**The side condition, and it is not cosmetic.** Writing `s₀ + s_∞` and computing
`ℓ(K − s₀ − s_∞) ≥ g − 2` treats `s₀, s_∞` as *degree-1* points. Over a non-closed field the
minimal closed points `q₀ ∈ π⁻¹(0)`, `q₁ ∈ π⁻¹(∞)` have residue degrees `e₀, e₁`, and an effective
`E ≥ q₀ + q₁` of degree `g` exists only if **`e₀ + e₁ ≤ g`**. Over `𝔽₂` with `g = 2` and
`e₀ = e₁ = 2` this witness does not exist — which is exactly the regime ADDENDUM 4 §4.4's
"only if" direction isolates. Secondly, the `g = 2` case above needs `π` chosen so that `s_∞` is
the hyperelliptic conjugate of `s₀`, whereas ADDENDUM 4 holds for any finite dominant `π`.

So: **the fixed-pair certificate route is dead on the campaign's own stratum** — on ADDENDUM 4's
authority, for every field; and the pencil above is a cheaper witness for the sub-case
`e₀ + e₁ ≤ g`. Do not re-run this experiment. Do not formalise either witness — ADDENDUM 4 §4.5
explains why (it needs `Sym^g C` / `Hilb^g`, and this tree constructs no curve other than `P¹`).

### 7.4 The live strategic question is R1 versus R2, and it is not "which is cheaper"

With the fixed pair dead, `spec-dd-r` ADDENDUM 4 §4.4 leaves exactly two repairs, and they differ
in kind, not only in cost:

* **R1** (`p1-aut` → `fibre-avoid` → `cert-relocalize`): let the certificate quantify over a twist
  `γ ∈ Aut(P¹_k)`. Proved correct **iff `|P¹(k)| ≥ g + 2`** — i.e. over every infinite field and
  over `𝔽_q` for `q ≥ g + 1`, and dead over small finite fields. Since `Challenge.lean` states the
  Jacobian over an **arbitrary** field and `archon-protected.yaml` forbids adding a hypothesis, R1
  **cannot discharge the challenge on its own**: it must be paired with the descent lane `dat-g`.
* **R2** (generalise `FinCoverData`'s piece type from basic opens of the two pinned charts to
  arbitrary affine opens of the relative curve): field-uniform, and ADDENDUM 4 §4.4 gives it a
  one-line justification — `supp D` is finite over `R`, hence contained in a single affine open of
  `C ×_k Spec R` (Stacks 0B8B), so a cover with one straddling piece always exists. Blast radius
  measured this round: `FinCoverData` is named in **28 files**.

The honest comparison is therefore *R1 + a full Galois-descent campaign* against *R2 + a 28-file
refactor*. Nobody has costed the second half of R1, and the roadmap's `p1-aut` leaf says "do not
attempt both". That decision is the highest-value thing the next session can make, and it should be
made with a costing of `dat-g`, not with a costing of `p1-aut` alone.

### 7.5 What `Challenge.lean:99` reduces to today

Composing with the frozen discharge `Jacobian C := (jacobianData C).J`, the target is now exactly:

> **a Zariski atlas of `pic0SigmaFunctor C`** — an index `ι`, schemes `X i`, maps
> `f i : yoneda.obj (X i) ⟶ pic0SigmaFunctor C` such that (1) each `f i` is a relatively
> representable open immersion, (2) `Sigma.desc f` is Zariski-locally surjective, (3) each chart's
> structure morphism is locally of finite type and the glued object is quasi-compact.

Sheafhood, the 01JJ gluing, the Σ-descent and both finiteness certificates are discharged.

**Three corrections a ground review forced on the first draft of this subsection, all of which
matter to anyone planning off it.**

* **The atlas is NOT finite, so the producer to aim at is `JacobianData.ofChartsOfCompactSpace`
  (`JacobianDataCharts.lean:199`), not `ofCharts`.** The chart index is
  `ChartIndex C := (m : ℕ) × {Σ // 0 ≤ Σ ∧ deg Σ = m·d₁ − g}` (`informal/w4-datb-worksheet.md:161`),
  a `Σ` over all `m : ℕ`, and the worksheet says at :66-71 that the `m`-strata do not collapse, so
  no uniform bound exists. `locallyOfFiniteType_gluedHom` never needed finiteness (being locally of
  finite type is local on the source); the whole finiteness burden therefore collapses onto the
  single statement `CompactSpace` of the glued object — which is the DAT-J image argument, a
  theorem about the Jacobian and not bookkeeping.
* **Clause (2) is not a free-standing leaf; it IS the gate.** The only builder of an `f i` is
  `abelSigmaChart` (`Picard/Pic0AtlasFromDivRep.lean:203`), which consumes
  `(divFunctor C π n).RepresentableBy`, and `divFunctor` is by definition the functor of *locally
  certified* families (`Picard/DivisorFamilyZarFunctor.lean:41-45`). So (2) asserts that certified
  families cover — which is exactly what the no-go denies. See §7.6.
* Only clause (3) is genuinely cheap.

Everything below the atlas — L9 through L14 — exists to produce (1) and (2).

## 7.6 The gate is L8, not U2 — and that is the round's main finding

Inbox **I-0365**. The framing "the divrep tail is independent of the certificate; the certificate
gates U2" is false, but not in the direction the tree assumed.

`DivFamZar` is **by definition** a quotient of *locally certified* families
(`Picard/DivisorFamilyZar.lean:224` the setoid, `:235` the def, `:71` `IsLocallyCertified` — note it
localises on the base only). So certificates are **free on the consuming side**:
`DivFamZar.exists_certChartCover` (`Picard/DivRepClassifyZarKit.lean:433`) is a landed theorem,
unfolded by every classifier keystone (`DivRepClassifyZar.lean:128/:176/:230`,
`DivRepClassifyZarSep.lean:361/:363`), and `IsDivRepClassify` (`DivRepClassifyZar.lean:90`)
quantifies over certified families as a *hypothesis*, so their scarcity makes it easier, not harder.

The bite is on the other side. The no-go (`DivSchemeCertZarC1.lean:123` — clause (c1) *is*
leak-freeness — and `:131`) says `DivFamZar` is blind to connected divisors meeting both pinned
fibres. So `divFunctor C π g` is a **proper subfunctor** of degree-`g` relative divisors.
Representing it is not the problem; the L9–L13 tail does that honestly. The problem is that a
too-small divisor functor **cannot cover Pic⁰**: the Abel map out of it is not Zariski-locally
surjective, because the classes whose only witnesses are the invisible divisors are never hit.

One nuance that sharpens where to look: the no-go's hypothesis is `IsPreconnected d.supportLocus`,
and **over a field it is vacuous** — the support of a divisor is a finite set of closed points, so
preconnected forces a single point, which cannot meet two disjoint fibres. The blindness is a
purely *relative* phenomenon: a family over a positive-dimensional base whose total support is a
connected horizontal curve sweeping from `π⁻¹(0)` to `π⁻¹(∞)` is invisible, and base shrinking does
not help because every neighbourhood of the crossing contains points on both sides. So
Riemann–Roch-level, fibrewise coverage is untouched — but local surjectivity of a *presheaf* map is
tested on arbitrary scheme tests, which is exactly the relative direction.

**Consequences.** (i) Stop calling U2 or the affine package "the gate": they are tail work and are
nearly finished. (ii) Do not attack L8 against `divFunctor` as it stands — it is arguably false,
not merely hard. (iii) Judge R1 and R2 by whether they widen `DivFamZar` enough for L8, not by
whether they make a certificate easier to prove. A third widening is worth costing beside them:
replace `IsLocallyCertified` outright by the standard relative effective Cartier divisor (finite
locally free of rank `g` over the base), which carries no chart-adaptation artifact at all.

## 7.7 ROUND-0071 AMENDMENT: §7.1's own L11 row is now stale, the same way §1 was

*Run 0071, task `ajcr-divrep`, 2026-07-28. Everything below was checked at HEAD or landed as
Lean this run; root build green at 9136 jobs.*

§7.1 was written to correct §1 for trusting a `MISSING` claim across an integrate commit. Its
own L11 row has now aged the same way, in one day, and by the same mechanism.

**§7.1 said:** "What is left of L11 is the general-test **classifier** and the two inverse
laws." **Truth at HEAD:** all three landed on 2026-07-27, in commits `31930badb` and
`aeb77e174`, as `Picard/DivRepGlobalClassify.lean` — `classifyGlobal` (`:204`),
`pullGlobal_classifyGlobal` (`:252`), `classifyGlobal_pullGlobal` (`:269`), plus
`toGlobalData` (`:288`) and the endpoint `DivRepAffinePullback.representableBy` (`:306`).
Sorry-free, and the root aggregator imports the file. So **L10 and L11 have zero remaining
obligations**, and the divisor-representability endpoint L9 is reachable from a single
structure.

**The chain below L9 is therefore one object, not five.** Everything from L10 to L13 collapses
to: produce a term of `DivRepAffinePullback` (`Picard/DivRepAffKit.lean:175`). By
`DivRepAffinePullback.ofPull` (`Picard/DivRepAffPullbackReduce.lean:140`) that is three fields.

**What this run landed, and one gating claim it retracts.** The roadmap leaf `…divrep.u2` and
`w4-ddr9-worksheet.md` §3.4 both describe the affine package as "U2 + choice bookkeeping",
which reads as though the bookkeeping sat behind the ε-identity. It does not:

* `Picard/DivRepAwaySpanGlue.lean` — the eight-field instance pack of the S5b gluing keystone
  `DivFamZar.exists_glue_of_away_compat`, discharged at the canonical away carriers
  `Localization.Away (f p)` / `Localization.Away (f p * f q)`. This pack was the mechanical
  obstruction between the atlas factorization (which returns a *bare* spanning family) and
  every gluing keystone (which wants carriers as instance data).
* `Picard/DivRepAffPullGlue.lean` — the chart pulls of one factorization glue, uniquely.
* `Picard/DivRepAffPullIndep.lean` — `divRepPullGlue_eq_of_chartFactors`: two *different*
  factorizations of the same morphism give the same class. **U2-free.**

The reason the last one is free is a property of a landed lemma nobody had used:
`divRepPullAt_mapAlgHom_eq_of_chartFactor` (`Picard/DivRepAffChartOverlap.lean:126`) compares
**any two chart presentations of the same morphism**, over any two carriers, restricted to any
common tower ring — it never asks that they share a factorization. So the cross-refinement of
two factorizations is handled by the very lemma that handles one factorization's own overlaps.

**What genuinely remains ε-gated**, and it is a smaller target than "U2 + bookkeeping":
`isDivRepClassify_pull` (the glued pulled class satisfies the characterizing clause) and
`DivRepChartFamily.IsCompatible` for the universal family — which by
`isCompatible_of_isDivRepClassify_divRepPullAt` is itself the per-chart clause, i.e. U2.
`pull_naturality` is still unwritten but is the same glue machinery as `pull`; its carrier
transport is landed (`Picard/DivRepAwayPush.lean`).

**A qualification a fresh-context review forced, and it is the honest limit of the above.**
"U2-free" is a claim about the *proof*, not about the gate. `DivRepChartFamily.IsCompatible`
has no producer, and its only intended producer is U2. So nothing above lets a consumer
actually instantiate the new theorems without proving U2 first: the set of unproved statements
is unchanged. What changed is its **partition** — factorization-independence is no longer a
second obligation standing beside U2 — and therefore the size of the remaining target. Read
the round's result as "the tail is one structure with two ε-gated fields", not as "a gate
cleared". The general form of this trap is inbox `I-0512`.

**Also landed but not yet consumed by anything**: the `pull` field itself is still not
*defined*. The ingredients are all here (`divScheme_exists_chartFactor` gives the
factorization, `exists_divRepPullGlue` glues it, `divRepPullGlue_eq_of_chartFactors` makes the
result choice-free), and assembling them is a `Classical.choice` over the factorization
characterized by the restriction property. That is the concrete next step and it is small.

**§7.6's finding stands and is unaffected.** L8 (local surjectivity of the Abel map out of a
too-small divisor functor) remains the campaign's real gate; nothing above touches it. What
changed is only that the *tail* below L9 is now one structure with one ε-gated field, so the
cost of the tail is no longer a reason to defer confronting L8.

## 7.8 ROUND-0071 s0004 AMENDMENT: the tail's two obligations are one, and the clause is local on the base

*Run 0071 session 0004, task `ajcr-divrep`, 2026-07-28. All Lean below is sorry-free,
kernel-checked (`lake env lean` exit 0 per file), rooted, and in a green root build at
9157 jobs. The reduction was independently audited by a fresh-context reviewer; what that
audit confirmed and what it qualified are both recorded below.*

§7.7 closed by naming the remaining ε-gated debt as **two** statements —
`isDivRepClassify_pull` and `DivRepChartFamily.IsCompatible` — and called the tail "one
structure with two ε-gated fields". That count was right about the fields and wrong about
the obligations: **the two are the same statement**, and the tail now has a producer.

**The endpoint from one hypothesis.** `Picard/DivRepAffPullClause.lean`:

> `divFunctor_representableBy_of_chartClause : IsChartClause U → (divFunctor C π g).RepresentableBy DivOver`

where `DivRepChartFamily.IsChartClause U` says: for every chart `(i,j)` and every
`ω : R_Z(i,j) →ₐ[k] S`, the chart pull `divRepPullAt U i j ω` satisfies `IsDivRepClassify`
for the chart morphism `Spec ω ≫ ChartMap i j`. That is *verbatim* the hypothesis
`isCompatible_of_isDivRepClassify_divRepPullAt` (`Picard/DivRepAffPullbackReduce.lean:98`)
already consumed — the reviewer verified this by a `rfl` proof of propositional equality of
the two `Prop`s, in both directions, so it is a **naming plus a proof, not a strengthening**.

**What made it work, and it is the reusable part.**

> `isDivRepClassify_of_forall_away` — **`IsDivRepClassify` is local on the base.** If every
> restriction of `F₀` to `Localization.Away (f t)` along a spanning family is classified by
> the corresponding restriction of `v`, then `F₀` is classified by `v`.

The predicate quantifies over *tower tests*, so its hypothesis data (a certified
representative plus a pair-chart framing) and its conclusion (an equality of morphisms) both
restrict; the framing pushes along the left leg into `T ⊗_S A` by
`map_window_frame_toSubmodule` at the **identity tower** — the `hβ` trick already inside the
landed `pullback_chart_divClassifyClause_compat`. Once that exists, `isDivRepClassify_pull`
is four lines: on the `t`-th piece of the atlas factorization the value *is* the chart pull
(`divRepPullValue_spec`) and the chart morphism *is* the restriction of `v.left`, so the
chart clause *is* the piecewise statement.

**Also landed, and cheaper than §7.7 priced it.** `pull_naturality`
(`divRepPullValue_naturality`, `Picard/DivRepAffPullNat.lean`) is ε-free **and performs no
gluing**. §7.7 called it "the same glue machinery as `pull`"; it is not — it is a witness
construction against `divRepPullValue_eq_of`. General form: once a choice-defined value has
an existential characterizing predicate *plus* a uniqueness theorem, every naturality
statement about it is a witness construction, never a second cover chase.

**A spelling hazard worth recording.** The locality lemma needs **two** declarations: the
per-piece overlap comparison in the `algebraMap` spelling, then the cover chase consuming it
by defeq. A single-declaration version does not elaborate — the pulled-back cover's index is
not `Fin m` on the nose, so the cover-spelled goal cannot see `f t`. This is exactly the
split the landed `pullback_chart_divClassifyClause_compat` uses, and now the reason is on
record.

**The qualifications, both of which a reader planning off this needs.**

* **No gate cleared.** Nothing here produces an `IsChartClause`: U2 is unproved, and per
  roadmap `…divrep.u2` it stays gated on the G-4 certificate discharge
  (`ThetaGeneratorSeed.certifiedFamily`, `Picard/DivSchemeEps.lean:237`, demands a *global*
  `IsCertified` over the chart ring). The R2 widening does **not** reach it: cert-r2's
  `DivFamZar.toAff` maps the old value into the widened one, which is the wrong direction
  for this obligation.
* **"One hypothesis" is about the new debt only** (the reviewer's qualification). The
  endpoint theorem still carries `hO`, `hχ` and the ambient curve instances, so a proof of
  `IsChartClause` alone does not give representability for an arbitrary `C`.
* **§7.6 stands untouched.** L8 — local surjectivity of the Abel map out of a too-small
  divisor functor — remains the campaign's real gate, and is arguably false as stated. None
  of the above bears on it.

**DAT-J moved too — but see §7.9, which corrects the last paragraph of this subsection**
(`Picard/JacobianDataAbelImage.lean`). w4-datj §2.2's a-posteriori qc
argument has four steps; three were landed separately with nothing joining them. A
point-surjective morphism from `DivScheme g` onto `J.left` now yields `QuasiCompact J.hom`
(DD-Q's `compactSpace_divScheme` instance + DJ-0), and `JacobianData.ofChartsOfAbelImage`
supplies `ofChartsOfCompactSpace`'s `CompactSpace` hypothesis from it — which is what §7.5's
first correction needs, since the chart index is infinite. What remains of DAT-J is step 3
alone: surjectivity of the Abel map on points, which needs `divRep`, and which per §0.5 must
stay Challenge-free (`exists_effective_of_picClass`, never `riemann_inequality_curve`).

## 7.9 ROUND-0071 s0006 AMENDMENT: U2 is an equation, and DAT-J's "step 3" was two steps

*Run 0071 session 0006, task `ajcr-divrep`, 2026-07-28. All Lean below is sorry-free, kernel-checked
(`lake env lean` exit 0 per file), rooted, in a green root build at **9176 jobs**, and axiom-probed
at `propext / Classical.choice / Quot.sound` **with a control (`Jacobian`) that still reports
`sorryAx`**, so the readings mean something.*

### 7.9.1 U2 carries no quantifier: it is an equation between two landed morphisms

§7.8 reduced the tail to one hypothesis, `IsChartClause`, and read it as the ε-identity — a
*submodule* identity, quantified inside `IsDivRepClassify` over all tower tests and all framings.
That quantifier is not there. `Picard/DivRepChartRange.lean`:

> `isDivRepClassify_iff_divRepClassifyZar_left_eq` :
> `IsDivRepClassify F₀ v ↔ (divRepClassifyZar … F₀).left = v`

**Why, and this is the whole content.** `divRepClassifyZar` is **total** — defined for every
locally certified class over every affine test, with no hypotheses beyond the ambient ones — and
`isDivRepClassify_unique` makes it the *unique* morphism satisfying the clause. So the clause is
not a property one verifies of `v`; it says `v` **is** the classifier. Forward is uniqueness,
backward is a rewrite. The statement names no chart family and no universal point, so it serves
anyone holding an `IsDivRepClassify` obligation.

Hence, and **stated as an `iff` on purpose** (inbox `I-0571`: a restatement is a reduction only
when the converse is proved — both directions are):

> `DivRepChartFamily.isChartClause_iff_forall_classify_eq` :
> `IsChartClause U ↔ ∀ i j, (divRepClassifyZar … (U i j)).left = ChartMap i j`

So **U2 is a per-chart equation between two morphisms `Spec R_Z(i,j) ⟶ DivScheme g` that both
already exist as landed terms.** Reading off the existential:

> `divFunctor_representableBy_of_chartRange` :
> `(∀ i j, ∃ F, (divRepClassifyZar … F).left = ChartMap i j) → (divFunctor C π g).RepresentableBy DivOver`

Since `divRepClassifyZar` is injective on classes (`eq_of_isDivRepClassify`), representability of
`divFunctor` is *equivalent* to surjectivity of the classifier at every affine test; what is new is
that **surjectivity at the chart rings alone suffices**. The remaining debt is a *preimage under a
landed map* at `glueData`-many points.

**No gate cleared.** Nothing produces a term of `DivFamZar C (DivCarveChartRing … i j) π g`; U2 is
unproved, and the endpoint still carries `hO`, `hχ` and the ambient curve instances, so "one
equation" describes the debt and not representability for an arbitrary `C`.

**But the G-4 quote should be re-measured, not re-quoted.** This row has already outlived one stale
blocker (the I-0234 `windowS` strengthening, which was `done`). Two facts say the same scrutiny is
owed to "U2 is gated on a *global* `IsCertified` over the chart ring":

* `Picard/DivSchemeCertZarSeed.lean` exists to remove exactly that. Its docstring states that
  **nothing downstream of `DivFamZar` asks for a certificate over `R` itself**, and
  `ThetaGeneratorSeed.divFamZar_of_forall_away_certified` (`:132`) produces the class from
  **away-local** certificates. `Picard/DivSchemeCertZarPointwise.lean` goes further —
  `divFamZar_of_forall_prime_away_certified` (`:181`) needs a certificate only *after shrinking at
  each prime*, which is the shape the support tube actually produces.
* Inbox `I-0602` (cert-r2, machine-measured) gives the general trap: the chart-typing that
  `divRepClassifyZar`'s signature *appears* to require is not what its body consumes — `divFamEps`
  reads only the `eqns` field, through `divisorWindow`, and the framing clause mentions no cover, no
  piece and no chart typing.

Neither fact proves the gate is stale and this amendment does not claim it. It says: **measure it in
Lean before spending another session treating it as a wall.**

### 7.9.2 DAT-J: §7.8's closing paragraph undercounted, and the assembly was never written

§7.8 ends "*What remains of DAT-J is step 3 alone: surjectivity of the Abel map on points*". Step 3
was **two** statements, and one of them was not mathematics about the Jacobian at all.

* **The bridge** (`Picard/JacobianDataAbelSurj.lean`). §2.3's argument (the `fiberTwist` shift plus
  `exists_effective_of_picClass`) delivers, for a point `y`, a **morphism** `Spec κ(y) ⟶ DivScheme g`.
  The qc field consumes `Function.Surjective abel.base`. **Nothing converted one into the other.**
  `surjective_of_forall_exists_residueField_lift` does: `κ(y)` is a field hence `Spec κ(y)` is
  nonempty, and mathlib's `range_fromSpecResidueField` pins the range to `{y}`. Pure scheme
  topology — no curve, no Picard functor, no divisor scheme — hence reusable. With DJ-0 it gives
  `quasiCompact_of_forall_residueField_lift_from_divScheme`, `JacobianData.ofAbelLifts` and
  `JacobianData.ofChartsOfAbelLifts` (the infinite-atlas producer §7.5 asks for).
* **The DAT-G handoff** (`Picard/JacobianDataFromPicRepDatum.lean`). w4-datj §1.1 pins DJ-IN =
  `PicRepDatum k k C` and asserts the packaging is free because the `rep` field types are
  definitionally equal. **The packaging had never been written**, and the tell is sharp:
  `PicRepDatum` occurred in *no other Lean file in the tree*, its defeq recorded as an `example`
  that nothing consumed. `PicRepDatum.toJacobianData` is the first declaration to use it, so the
  worksheet's assertion is now a machine fact rather than an assertion.

**What DAT-J now owes is visible in one signature and nowhere else** —
`PicRepDatum.toJacobianDataOfAbelLifts` takes exactly a `PicRepDatum k k C` (DAT-G/DAT-G0,
divRep-gated) and a per-point lift. Both remain open; the lift stays binding-Challenge-free per §0.5
(`exists_effective_of_picClass` / `riemann_inequality`, **never** `riemann_inequality_curve`).

### 7.9.3 §7.6 stands

L8 — local surjectivity of the Abel map out of a too-small divisor functor — remains the campaign's
real gate and is arguably false as stated. Nothing above bears on it. The tail becoming an equation
is not progress toward L8, and should not be read as any.

## 7.10 ROUND-0071 s0008 AMENDMENT: the wall was measured off the wrong seed, and the file that
disproves it is unrooted

*Run 0071 session 0008, task `ajcr-divrep`, 2026-07-28. Everything below was read at HEAD. **Neither
new Lean file completed a kernel check** — the box was swap-bound (load ~70, <1 GB free) and produced
zero `.olean`s workspace-wide for 40+ minutes, so both files are committed and **unverified**. Read
the reductions as measured statements about what exists, not as green Lean.*

### 7.10.1 Two seeds over one ring, and only one of them is gated

§7.9.1 and the `…divrep.u2` row both quoted, as U2's residue, the germ-divisibility wall of I-0302
§residual 2b/2c — `SeedUnivRDN`. That is measured off `ThetaGeneratorSeed.isGenerator_seedUniv'`
(`Picard/DivSchemeRedesignSeedUniv.lean:205`), which genuinely takes `SeedUnivRDN` plus a per-point
`hfib`. **It is not the only generator over the chart ring.** Enumerating every declaration in the
tree whose conclusion is `(…).IsGenerator`, exactly one is ungated over `R_Z`:

> `PointwiseAchiever.isGenerator_highWindowPointwiseGeneratorSeed`
> (`Picard/DivSchemeHighWindowPointwiseGenerator.lean:89`)

at `K = divUniversalSeedK` over `R_Z = DivCarveChartRing` — U2's own ring and U2's own seed module —
from `hO`, `hχ` and `hb : 0 < windowBound π hπ` **only**. `isGenerator_pointwiseGeneratorSeed` (`:274`)
takes `PointwiseSeedRDN` alone, and `pointwiseSeedRDN_of_highWindow`
(`…HighWindowQuotientBridge.lean:119`) discharges *that* from `hb`.

Hence `Picard/DivRepChartClassUniv.lean` (commit `76759f498`): `ε` of the certified family of the
high-window universal seed **is** the universal tautological pair, from `IsCertified` alone. The other
three inputs of the landed ε-projection identity (`DivSchemeEps.lean:312`) are all available at the
universal point — the generator clause above, the second-window containment
`divUniversalSndWindow_le_highWindow_divisorWindow` (`…SecondContainment.lean:114`) *for that same
seed*, and **both** `thetaGluedEval` surjectivities from the certificate itself
(`DivisorAdaptation.IsCertified.thetaGluedEval_surjective`, `DivisorThetaFibreData.lean:271`; the
second window `M + s` is `≥ M`). No transport is needed: `divUniversalSeedK` is *syntactically* the
`K` binder of the ε-identity at `x₁ = divUniversalFstWindow`.

**So U2 owes one certificate and one scalar** — `IsCertified g` at the universal seed, which is
precisely the widened certificate lane's endpoint shape (I-0565), and `hb`, used only to get
`0 < windowS_choice`. Since `windowBound` is a `Classical.choose` from a predicate upward-closed in
`b` (`UniformVanishing.lean:71`), "some valid bound is positive" is trivial while "the chosen one is"
is not: normalise the choice rather than proving positivity of it.

### 7.10.2 Why nobody saw it — rootedness is not sorry-freeness

The `DivSchemeHighWindow*` family is **44 files, zero `sorry`s, zero occurrences in
`AlgebraicJacobian.lean`**. Only 6 of the 44 are in the root import closure, nothing outside the
family imports its two endpoint files, and one transitive member
(`Picard/DivSchemeWindowMulGeneral.lean`) has **no `.olean` at all** — it has never been compiled in
this tree. So no root build ever elaborated it, no `sorry` census counted it, and no axiom probe
measured it.

This is inbox I-0362 (unrooted = not measured) at 44-file scale, on the critical path, and it is the
mirror of §7.1's own lesson: §7.1 warns against trusting a **MISSING** claim across an integrate
commit; this is a **discharge** hiding outside the root cone. Check rootedness *separately* from
sorry-freeness — `grep -c <module> AlgebraicJacobian.lean = 0` means "not measured", not "not proved".

### 7.10.3 DAT-J step 3 is a square, because the relative wall is vacuous fibrewise

§7.9.2 recorded the remaining lift as "divRep-gated". The **morphism half is neither gated nor
missing**. `Picard/DivisorFamilyFieldSurj.lean` — *rooted*, sorry-free, and with zero consumers when
measured — carries the whole fibrewise chain, and it is short for a reason:

> `DivisorAdaptation.isCertified_of_deg` (`:104`): over a **field**, an adaptation whose presentation
> divisor has degree `n` is `IsCertified n`.

All seven clauses fall out of a bare degree equation: projectivity and both flat-cokernel clauses are
`Module.Free.of_divisionRing` instances, `(c1)` finiteness is `moduleFinite_colength`, and the `(c2)`
rank clause is the *unconditional* CRT identity `deg_presentationDivisor`. No support separation —
which the file records as a deviation of record, since full support separation is *unachievable* when
a support point lies in both charts' overlap. On top: `exists_divFam_divFamDivisor_eq` (`:147`) and
`effectiveDivisorClassifyZar` (`:217`).

**This is the constructive form of §7.6's own argument.** §7.6 observes the `DivFamZar` no-go is a
purely *relative* phenomenon, vacuous over a field. The mirror is that the certificate difficulty
which makes U2 hard **does not exist fibrewise**. Any obligation phrased over a residue field should
be priced against this file, not against the relative certificate machinery.

What is left is that the classification sits over the *right point*: `effectiveDivisorClassifyZar_spec`
(`:231`) never mentions `abel`. So step 3's residue is an **Abel-compatibility square** plus a
Riemann–Roch effectivity input — the "groups agree ≠ maps agree" shape (I-0525) — stated as
`IsAbelClassifyCompatible` / `exists_residueField_lift_of_abelCompatible` in
`Picard/JacobianDataAbelSquare.lean` (commit `cf73332ac`), the second giving `hlift` verbatim as
`ofAbelLifts` consumes it. The effectivity input stays binding-`Challenge`-free per §0.5.

### 7.10.4 §7.6 still stands

Unchanged by all of the above, and worth repeating because two reductions in one session invite the
opposite reading: **L8 is still the gate and is arguably false as stated.** Nothing in §7.10 bears on
it.

## 7.11 ROUND-0071 s0010 AMENDMENT: both of U2's inputs were artefacts of how the residue was spelled

*Run 0071 session 0010, task `ajcr-divrep`, 2026-07-29. Every theorem below was elaborated with
zero diagnostics against the built `.olean`s; **none of the three modules has been through a `lake
build`** and none is imported by `AlgebraicJacobian.lean`, so no root measurement covers them.
§7.11.4 states exactly what that does and does not license.*

§7.10 priced U2 as "one certificate plus one scalar". Both halves of that pricing were about the
*spelling* of the residue rather than about mathematics, and both are now removed.

### 7.11.1 The scalar was discharged in the tree before the row that owed it was written

`Picard/DivRepChartClassUnivFree.lean` (commit `877459d8c`):

> `windowBound_pos_of_genus_ne_zero` : `g ≠ 0 → 0 < windowBound π hπ`

The content is `genus_eq_zero_of_windowBound_nonpos` (`RiemannRoch/WindowLedgerF3.lean:68`): if the
chosen bound were `≤ 0`, the vanishing it certifies fires at the **zero** divisor, so `h¹(𝒪) = 0`,
and with `h⁰(𝒪) = 1`, `χ(𝒪) = 1 − g` that forces `g = 0`. So `hb` is a *genus disjunction with a
landed degenerate branch*, not an obligation — and `WindowLedgerF3` had already used exactly this
disjunction twice for its own budget bounds (`:91`, `:106`).

§7.10 warned that `windowBound` is a `Classical.choose` from a predicate upward-closed in `b`, so
"some valid bound is positive" is trivial while "*the chosen one* is" is not, and told the next
session to normalise the choice. That reasoning is correct and was the wrong question: nothing needs
to know whether the chosen bound is positive, because the case where it is not is a case where
`g = 0`. **General form: before pricing a side condition, ask what its negation implies about the
ambient data — a hypothesis whose failure collapses the whole setting is a disjunction, not a debt.**

### 7.11.2 The certificate was being demanded at a `Classical.choose`, which no producer can hit

Every prior statement of U2's residue was phrased at `ThetaGeneratorSeed.divisorAdaptation`
(`Picard/DivSchemeFamily.lean:367`) `= (exists_divisorAdaptation …).some`. So the obligation read
*"`IsCertified g` for the adaptation the extraction happened to pick"* — unusable by any producer
that builds its own cover and certifies **that**, which is what every certificate-assembly route
does. `Picard/DivRepChartClassUnivAny.lean` (commit `4cff9b00c`) replaces it with

> `ThetaGeneratorSeed.HasCertifiedAdaptation n D hD` : `∃ A : DivisorAdaptation C R π (D.localEquations hD), A.IsCertified n`

and re-derives the whole U2 package from it. Three landed facts make this a theorem rather than a
weakening:

* `divisorWindow` *"depends only on `d`, not on any chart adaptation"* — its own docstring
  (`Picard/DivisorFamilyWindow.lean:101`), and `divFamEps` is two `divisorWindow`s;
* `divisorWindow_eq_of_le_of_isCertified` (`Picard/DivSchemeEps.lean:196`) takes an **arbitrary**
  `A : DivisorAdaptation C R π d` and concludes about `d` alone;
* `CertifiedDivisorFamily` (`Picard/DivisorFamily.lean:452`) is the triple
  `(eqns, adaptation, certified)` and never mentions the extraction.

`hasCertifiedAdaptation_of_divisorAdaptation` records that the old spelling is a special case — as a
lemma, so the relation between the two is machine-checked rather than asserted in prose.

### 7.11.3 The residue is now a single type mismatch, and it is the whole critical path

> **RETRACTED THE SAME SESSION, by a fresh-context review (inbox `I-0705`, confirmed by the no-go's
> own owner). Read this subsection as UNPRICED, not as "one type mismatch".** The table below is
> correct about the two carriers and wrong about the *status* of the chart-typed statement, which it
> treats as merely open. `forall_not_isCertified_of_straddling`
> (`Picard/DivisorFamilyAffStrict.lean:127`) concludes `∀ (A : DivisorAdaptation C R π d) (n : ℕ),
> ¬ A.IsCertified n` for a connected `d` whose support meets both pinned fibres — which is exactly
> the negation of `HasCertifiedAdaptation` at the same binder.
>
> **And the sharp form is worse, in a way that exonerates §7.11.2's weakening.** Because that no-go
> quantifies over **all** `A`, it refutes the *old* spelling too: `(D.divisorAdaptation hD).IsCertified g`
> is one instance of that `∀`. So the existential did not introduce any falsity — if the high-window
> universal seed's local equations straddle, **both** residues are false, and every re-scope of the
> `…divrep.u2` row has been pricing a false statement. §7.11.2 stands as a *reduction* (the ε layer
> genuinely does not care which adaptation, and that is kernel-checked); what does not stand is
> calling the remainder a type mismatch.
>
> **The decisive unmeasured fact, for the old residue as much as the new:** is
> `(univSeed …).localEquations`'s `supportLocus` preconnected with points off `V₀` and off `V₁`? No
> file in the tree measures it. Until it is measured this row is unpriced. **And note which way it
> cuts: if the universal seed straddles, R2 is not an inconvenience for divrep — it is the only
> route, because no chart-typed adaptation can ever certify.**
>
> The methodological error is recorded as `I-0707`: this session crossed the new existential against
> its *producers* and never against the tree's *refutations*.

With the generator clause free (`isGenerator_highWindowPointwiseGeneratorSeed`, ungated over `R_Z`),
the scalar free (§7.11.1), the adaptation choice free (§7.11.2) and the ε-identity a corollary
(§7.10.1), what U2 owes is: **some certified adaptation of the high-window universal seed's local
equations over `R_Z`, at degree `g`.** The obstruction to discharging it from the R2 lane is not
mathematics but a carrier:

| wanted | supplied |
|---|---|
| `DivisorAdaptation.IsCertified` (`DivisorFamily.lean:426`) | `AffAdaptation.IsCertified` (`DivisorFamilyAffAdaptation.lean:252`) |

by `exists_isCertified_of_seed_of_swallowing_affineOpen` (`DivisorFamilyAffSeedEndpoint.lean:78`).
`DivFamZar.toAff` runs chart-typed → widened, the wrong direction; and `DivisorAdaptation` extends
`FinCoverData`, so a widened cover has no chart typing to recover — manufacturing one is exactly
what protection `I-0492` clause 3 forbids. Either a widened → old bridge lands, or the ε layer is
re-typed onto the widened adaptation. **The second is cheaper than it looks**, for the same reason as
§7.11.2: `Picard/DivisorFamilyAffFraming.lean` already carries `CertifiedDivisorFamilyAff.eps` and
`IsPairChartFramed` over the widened carrier, elaborating, because `divFamEps` reads only `eqns`.

### 7.11.4 What the verification does and does not license, and one error it caught

`windowBound_pos_of_genus_ne_zero`, `certifiedFamilyOfAdaptation`, `HasCertifiedAdaptation`,
`hasCertifiedAdaptation_of_divisorAdaptation` and `divFamEps_certifiedFamilyOfAdaptation` were each
elaborated standalone against the built `.olean`s with **zero diagnostics**. That is a kernel
elaboration of statement *and* proof. It is **not** a `lake build` of the modules: three builds were
launched under the mkdir mutex this session — one failed transiently (a concurrent build in the same
tree removed olean output directories mid-run; four AJCR lanes were building at once) and one timed
out at 8000 s inside the ~9000-job cone the 2026-07-29 mathlib restore invalidated. So: read these as
verified theorems in unrooted modules, and root them once a green build exists.

**The first kernel check `DivRepChartClassUniv.lean` ever received found a real error in it** — the
file §7.10 committed unverified. It called `hc.thetaGluedEval_surjective hO hchi …`; dot notation
does not work there, because `DivisorAdaptation.IsCertified.thetaGluedEval_surjective` has `C`, `π`,
`hπ` as **explicit** section variables *preceding* `hc` (`Picard/DivisorThetaFibreData.lean:56-58`),
so `hO` is fed into the `C` binder. Fixed to the explicit spelling. **General form: dot notation on a
structure-projection lemma silently reassigns your arguments when the namespace owner has explicit
variables before the structure argument — and no `sorry` census sees the result.**

### 7.11.5 §7.6 still stands

**L8 remains the gate and is arguably false as stated.** Two spellings collapsing in one session is
exactly the reading §7.10.4 warned against: nothing in §7.11 bears on local surjectivity of the Abel
map out of a too-small divisor functor.
