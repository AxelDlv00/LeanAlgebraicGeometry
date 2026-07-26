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
