All four sites and the definitions are captured. Here is the verbatim record.

## Site 1 — `Pic0ChartUnivReduce.lean:160-161` (docstring, inside the `IsChartLocusFibre` doc-comment)

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0ChartUnivReduce.lean`

Lines 153-165 (the bullet list; :160-161 is the third bullet):

```
Modulo that retraction, what a lane owes is:

* `r`: the divisor family over the locus whose class is the given one.  This is the
  classifier `divRepClassifyZar` applied to the canonical-section family, i.e. CHART-U(c)'s
  construction;
* `sq`: that its chart value *is* the given class, which is the classifier's characterising
  property;
* `exists_factor`: that two points with the same class agree, i.e. the **relative form of
  DAT-C GAP-2** (`Scheme.CurveDivisor.eq_of_picClass_eq_of_h0_one` in families).
```

Note: this site does NOT say "nothing in the tree produces it". It names the field as "the relative form of DAT-C GAP-2" and points at a field-level keystone "in families". Also relevant, from the same file's module docstring, lines 21-34 (table + prose):

```
| `exists_factor` | uniqueness of the normalized representative | **the relative form of GAP-2** |
...
So `W` needs only B-4 (**not** "nothing" — retracted below), `sq` is a property of whatever
`r` is, and the genuine content is
concentrated in `r` (a construction, from the classifier) and `exists_factor` (relative
GAP-2).
```

And lines 196-204 (docstring of `injective_of_isChartUniv`):

```
The converse direction of the reduction, and the reason it is a reduction rather than a
restatement: a lane that obtains `IsChartUniv` has, for free, the injectivity statement that
`ChartFibrePresented.exists_factor` is the hard half of.  So there is no route to `hf` that
avoids relative GAP-2 — the gate is real, and this file has moved it rather than removed it.
```

Lines 138-151 of the same docstring carry an earlier retraction and the fork warning ("If those headers are right this definition is **unsatisfiable**... A lane must decide that fork before attacking `exists_factor`.").

## Site 2 — `Pic0ChartAbelNonInjective.lean:75-90` (module docstring, closing paragraphs)

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0ChartAbelNonInjective.lean`

```
**AND HERE IS THE LIMIT OF THAT OBSERVATION, which item 3 must not be read past.**  Every anchor
in item 3 is fibrewise over one field: `CurveDivisor` over `K`, `h⁰` a `finrank` over `K`,
`degAt` evaluated at `overSpec k K`-points.  The obligation is **general-test**: injectivity of
`.app (op Y)` at arbitrary `Y`, and correspondingly distinctness in `divFamZar C π n T` at
arbitrary `T`.  A fibrewise anchor does not settle a general-test statement, and the brick that
would bridge them is *relative* GAP-2 — exactly `ChartFibrePresented.exists_factor`
(`Pic0ChartOpenImmersionCriterion.lean:140`), which `Pic0ChartUnivReduce.lean:160-161` names as
"the relative form of DAT-C GAP-2" and which **nothing in the tree produces**: no declaration
concludes `s₁ = s₂` for two `divFamZar` sections from an equality of their classes.

So item 3 **relocates** the fork; it does not shrink it.  What it changes is what a witness
should aim at: a bare "two divisors in one linear system" is the wrong target, because at `n = g`
with `h¹ = 0` there are none fibrewise — so a witness wants a point of the divisor scheme where
`H¹` fails to vanish, or a genuinely relative failure of uniqueness that no fibre sees.  Which
of those two it is, is undecided here.  (The degree-`g`/`h⁰ = 1` link is `ajcr-p4`'s measurement,
I-0888; the fibrewise/general-test caveat is a fresh-context review's, I-0923/I-0924.)
```

This is the only site in the project containing the phrase "nothing in the tree produces" about `exists_factor` (verified by grep: `nothing in the tree` appears in 8 other .lean files, all about different obligations). Its absence claim is precise and narrow: "no declaration concludes `s₁ = s₂` for two **`divFamZar` sections** from an equality of their **classes**."

## Site 3 — roadmap row `AJCR.w4-rep.datum.dat-c.c9-chartlocus.c9b`, clause (ii)

Title: `C9b: f_c and the (f, hf) chart pair (CERT-Sigma-gated; developable parametrically)`, status `blocked`, owner empty. Clause (ii) verbatim from the `summary` field:

```
 (ii) THE PROPERTY CLAUSE -- CERT-Sigma/divRep-gated through IsChartLocusFibre's exists_factor
      and the classifier-produced r. UNCHANGED. STILL THE REAL WALL, and r7 does not touch it.
```

Also in the same summary, lines further down:

```
STATUS STAYS BLOCKED, and the reason is now sharper than before: the gate is clause (ii) ALONE.
```

Clause (ii) says "CERT-Σ/divRep-gated" and "STILL THE REAL WALL". It does NOT say "relative GAP-2", and it does not make an absence claim about the tree.

## Site 4 — `Pic0ChartOpenImmersionCriterion.lean:210-218` (docstring of `isEmpty_forall_chartFibrePresented_of_not_injective`)

`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0ChartOpenImmersionCriterion.lean`

Line 214 is inside this docstring (:210-218):

```
/-- **Non-vacuity of `ChartFibrePresented`, from the necessary direction.**

If a chart map fails to be injective on the points of even one test, then no family of
`ChartFibrePresented` data exists for it.  In particular the criterion cannot be satisfied
for the *unrestricted* Abel chart, whose non-injectivity is the linear system `|D|`
(`Pic0AtlasFromDivRep.lean:54`): the criterion's hypothesis is genuinely as strong as the
conclusion, and `exists_factor` is not a clause one can talk one's way past.

The proof composes the two halves of this file, which is the point of having both. -/
```

Important: `Pic0ChartUnivReduce.lean:147` cites `Pic0ChartOpenImmersionCriterion.lean:214` as a site asserting non-injectivity of the Abel chart is FALSE-making. What :214 actually asserts is non-vacuity of the criterion plus a citation of `Pic0AtlasFromDivRep.lean:54` for the `|D|` claim — it is a docstring, and the `|D|` claim itself is not proved there. The same file also prices `exists_factor` at :190-194 (docstring of the criterion):

```
What is *not* free, and is the whole mathematical content, is `exists_factor`: a class that
agrees with a chart value must come from the locus.  For the Abel chart that is the relative
form of DAT-C GAP-2 (uniqueness of the normalized effective representative) fed through the
classifier — so the CERT-Σ gate is real, but it gates ONE field of ONE structure rather than
the whole certificate.
```

and at :95-102 (`injective_of_isOpenImmersion_presheaf`): "the relative form of DAT-C GAP-2 — so GAP-2 is *forced* by the target, not merely sufficient for it." Its own module docstring at :16 already calls the c9b row's one-clause pricing "wrong": "**That pricing is wrong, and this file is the correction.**"

## The Lean definitions

### `ChartFibrePresented` — `Pic0ChartOpenImmersionCriterion.lean:129-141` (actual Lean structure)

```lean
structure ChartFibrePresented {X T : Scheme.{u}}
    (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1) (g : yoneda.obj T ⟶ (pic0SigmaSheaf C).1)
    where
  /-- The locus of the test where the class named by `g` is a chart value. -/
  W : T.Opens
  /-- The chart point over that locus. -/
  r : (W : Scheme.{u}) ⟶ X
  /-- The square commutes: `r` names the class `g` restricted to `W`. -/
  sq : yoneda.map r ≫ f = yoneda.map W.ι ≫ g
  /-- **Coverage on the locus**: an `S`-point of `X` and an `S`-point of `T` carrying the
  same class factor through `W`, compatibly with both projections. -/
  exists_factor : ∀ (S : Scheme.{u}) (v : S ⟶ X) (w : S ⟶ T),
    f.app (op S) v = g.app (op S) w → ∃ u : S ⟶ (W : Scheme.{u}), u ≫ r = v ∧ u ≫ W.ι = w
```

Full binder list of `exists_factor`, as asked:
- quantifies over an **arbitrary scheme test object `S : Scheme.{u}`** (universally, no finiteness/affineness/Noetherian condition);
- a point `v : S ⟶ X` of the **chart source** `X` (not a map into the chart, a map of schemes into the representing scheme);
- a point `w : S ⟶ T` of the **test scheme** `T`;
- hypothesis: `f.app (op S) v = g.app (op S) w` — the two points have the **same class in the Σ-sheaf** `(pic0SigmaSheaf C).1`;
- conclusion: **existence** (not uniqueness — the file notes uniqueness is free from `W.ι` being mono, :125) of `u : S ⟶ ↑W` with `u ≫ r = v` and `u ≫ W.ι = w`.

So it is a coverage/surjectivity statement at every test, in the form "same class ⇒ factors through the locus". The sheaf `g` is an arbitrary test point of the target sheaf, bound *outside* the structure by the consumer.

### `IsChartLocusFibre` — `Pic0ChartUnivReduce.lean:166-171` (actual Lean `def`, a `Prop`)

```lean
def IsChartLocusFibre {D : Over (Spec (.of k))} (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ)) : Prop :=
  ∀ (T : Scheme.{u}) (g : yoneda.obj T ⟶ (pic0SigmaSheaf C).1),
    Nonempty (ChartFibrePresented C (abelSigmaChart C π n rep m Z hdeg) g)
```

Note it is at the **unrestricted** chart (`abelSigmaChart`, no `V`) — no `chartLocus`, no `V` appears, matching the retraction at :138-151.

### `abelSigmaChart` — `Pic0AtlasFromDivRep.lean:205-210` (actual Lean `def`)

```lean
def abelSigmaChart {D : Over (Spec (.of k))} (rep : (divFunctor C π n).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (n : ℤ)) :
    yoneda.obj D.left ⟶ (pic0SigmaSheaf C).1 :=
  rep.toSigmaExtension ≫ Over.sigmaExtensionNat (chartValueTrans C π n m Z hdeg)
```

Meaning (from its docstring :197-204): the morphism of big-site presheaves sending a `D`-point to the degree-zero class of the divisor family that point names; `rep` is a hypothesis, never constructed in that file.

## Two things bearing on whether the new file's characterisation is accurate

The new file's own import-closure measurement checks out. I re-derived the closure independently: `AlgebraicJacobian.Picard.DivSchemeMonoBridgeRel` is in the import closure of **none** of `Pic0ChartPair`, `Pic0ChartUnivReduce`, `Pic0ChartOpenImmersionCriterion`, `Pic0ChartAbelNonInjective`, `Pic0ChartRestrictedFibre` — nor of `Pic0ChartAbelForkReduce` itself. Its claim that `divFamEps` *is* in its own closure also checks out (`DivisorFamilyWindow`, where `divFamEps` is defined at :260, is in the 420-module closure).

But "four sites price it at the relative form of DAT-C GAP-2" is a loose aggregation. Only two of the four use that phrase for `exists_factor` (site 1 at :160-161 and site 4 at :190-194 / :101). Site 3 (the roadmap clause (ii)) says "CERT-Sigma/divRep-gated" and "STILL THE REAL WALL" without the GAP-2 phrase; site 2 quotes site 1 rather than pricing independently. And only ONE site — site 2 — makes the "nothing in the tree produces" absence claim, which is stated about `divFamZar` sections specifically. The landed relative mono the new file offers as the counterweight, `divFam_divEq_of_eps_eq_total` (`/home/axel/.../AlgebraicJacobian/Picard/DivSchemeMonoBridgeRel.lean:417`), concludes `DivFam.mk G = DivFam.mk G'` from equality of **ε-pairs**, at a pinned degree `g`, with `hOk`/`hχk` — not from equality of **classes**, and on `DivFam` not `DivFamZar`. So it does not on its face contradict site 2's absence claim; the new file says as much itself ("Whether that half factors through the ε-window ... is **not settled here**"), but its headline sentence at :49-51 ("the tree already has the harder-looking one") reads more strongly than that caveat supports.
