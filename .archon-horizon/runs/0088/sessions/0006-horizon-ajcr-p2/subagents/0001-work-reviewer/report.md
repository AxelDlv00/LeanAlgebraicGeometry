Verdict, findings, and the two claims I could not settle.

## Verdict: CHURNING toward over-claim, not stuck

Two of your four claims are sound results. The other two are sound *Lean* wrapped in framing that my probes refute, and the file's header now asserts a proof that does not exist. The identities are real; the repricing they are sold as is not.

Note first: **the file changed under me.** My brief described 220 lines / 6 declarations / commits `4fb9d5e9c3`+`e14661030b`. At HEAD (`d098e5bbf9`) it is **345 lines / 8 declarations**, disk blob == HEAD blob. I audited the 345-line version. Oleans verified newer than sources before every probe.

## Findings, most severe first

**1. REFUTED — `Pic0ChartAbelForkReduce.lean:74` cites a declaration that does not exist, and it is the one carrying "the residue is not plumbing."**

> "That dichotomy is not left as prose: `h0_eq_one_of_relPicSeparates_field` below **proves** the forcing direction at a field, from the rank anchor."

Grep over `AlgebraicJacobian/` returns exactly one hit — line 74 itself. Kernel-confirmed in a scratch importing only your module:

```
#check @AlgebraicGeometry.h0_eq_one_of_relPicSeparates_field
-- error: Unknown identifier
```

The declaration that *is* there, `effective_and_picClass_eq_of_picClass_eq_field` (`:252`), proves the other direction and strictly less: class equality at a field yields GAP-2's `hD`/`hD'`/`hcl`. It says nothing about `h⁰ = 1` being *forced*. Lines `:245-251` then build a two-branch dichotomy on the missing lemma. This is your fourth workspace instance of the cited-name failure (I-0994, I-1073). Write it or delete the sentence — do not rephrase.

**2. REFUTED — claim (4)'s "strictly weaker" framing. The converse is free, so the residue is the fork's obligation renamed.** This is your question B, and it settles against you.

```lean
theorem relPicSeparates_of_injective_chartValue [GeometricallyReduced C.hom]
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor) (A : Type u) [CommRing A] [Algebra k A]
    (hinj : Function.Injective (chartValue C π n m Z (overSpec k A))) :
    RelPicSeparatesDivFamZar C π n A
```

Sorry-free, axioms `[propext, Classical.choice, Quot.sound]`. It needs one naturality lemma, also free (three lines from `DivFamZar.picClass_mapAlg` + `relPicMap_mk`):

```lean
relPicMk C (overSpec k A') (DivFamZar.mapAlgHom φ F).picClass
  = relPicMap C (Over.overSpecMap φ) (relPicMk C (overSpec k A) F.picClass)
```

then two `divFamZarAffineEquiv_symm_apply_val` rewrites and `divFamZarAffineEquiv.symm.injective`. With your own `:218` this is an **iff**. I also proved `IsChartLocusFibre → RelPicSeparatesDivFamZar` at every `A`, using *your* `not_isChartLocusFibre_of_divFamZar`. So the commit's "strictly weaker than that — one ring, no test object, no chart, no twist, no representing object" describes the **spelling**, not the strength. I-1024, I-0896.

**3. REFUTED — the "modulo `picFromBase`" discount is empty where the fibrewise arguments live.** Docstrings `:177`, `:207-215` and `:329` sell the negative branch as easier because `relPicMk` quotients by `picFromBase`, and `:177` calls it "the weakest form of the separation the fork needs." At a field test `picFromBase C (overSpec k K) = ⊥` (`Spec K` subsingleton; `picFromBase_eq_bot_of_subsingleton`, `Tangent/RelPicPointTest.lean:77`), so there the residue **is** injectivity of `picClass`, no quotient — proved as `relPicSeparates_iff_injective_picClass_field`. And in general the residue *implies* injective `picClass` unconditionally (`congrArg relPicMk`), so it is the **stronger** of the two, never the weakest form.

**4. Your question D, header's MEASURED claim: CONFIRMED, with two omissions.** Re-measured independently from HEAD blobs, 771 modules, transitive closure per module. `DivSchemeMonoBridgeRel` is in the closure of none of `Pic0ChartPair` (321), `Pic0ChartUnivReduce` (328), `Pic0ChartOpenImmersionCriterion` (322), `Pic0ChartAbelNonInjective` (330), `Pic0ChartRestrictedFibre` (334). Exactly 7 modules have it; sole direct importer `DivRepClassifyZarSep`. But: `Pic0ChartAbelForkReduce` itself does not have it either (331), so the finding is about all six files including the one reporting it; and the 7 include `DivRepChartRange` and `DivRepAffPullClause` — two of the five rep producers your own `:294-295` lists — which is where a class→ε-window bridge would live. Filed as I-1151.

**5. Cited names, question D: one is outside the closure and the file now says so; the rest check.** `PicEtAff.unit_injective`, `abelDiv_val`, `relPicMk`, `picFromBase`, `divFamEps`, `chartValue_mem_pic0Subgroup`, `not_isChartLocusFibre_of_divFamZar` all `#check` clean. `divFam_divEq_of_eps_eq_total` and `Scheme.CurveDivisor.eq_of_picClass_eq_of_h0_one` are **outside** the closure — and `:70-71` now flags exactly that, correctly. Good.

**6. Question C, claim (1): CONFIRMED SOUND, and I found no missed route.** `chartValue_eq_iff_abelDiv_eq` (`:141`) is a correct cancellation, and I strengthened it to show the fibres are index-independent outright:

```lean
theorem chartValue_fibres_index_independent (m m' : ℕ) (Z Z' : …) …
    (chartValue C π n m Z T s₁ = chartValue C π n m Z T s₂)
      ↔ (chartValue C π n m' Z' T s₁ = chartValue C π n m' Z' T s₂)
```

plus injectivity index-independence, both axiom-clean. On the `hdeg` route you asked about: `chartValue_mem_pic0Subgroup` (`DivSchemeAbel.lean:382`) consumes `hdeg` only to make three *degrees* sum to zero at field points. Degrees are constant on the fibre, so landing in `pic0Subgroup` cannot separate two sections with equal `chartValue`. `hdeg` is decoration **for the fibre question**, as you say. Your `degAt_chartTwist_eq_chartParam` (`:313`) is the right way to say it.

**7. Question A, vacuity: the residue is a genuine statement about the curve — NOT the `HasDivFunctor` failure.** `C` occurs essentially (in `DivFamZar C A π n`, in `relPicMk C`, in `overSpec k A`); it is not closable by `rfl`/`trivial`; and the `Subsingleton (DivFamZar …)` inhabitant is degenerate but not the only reachable one — the residue is *equivalent* to something with real content (finding 2), so it cannot be vacuous. Where the sufficiency theorem is weak is different: it is not vacuous, it is circular.

**8. Question E, claim (3)/(4) vs `exists_factor`: your characterisation of the four sites is accurate; your strength comparison is not.** The sites say what you report (`Pic0ChartUnivReduce.lean:160-161` "the relative form of DAT-C GAP-2"; `Pic0ChartAbelNonInjective.lean:80-82` "**nothing in the tree produces**"; `Pic0ChartOpenImmersionCriterion.lean:214-216` "not a clause one can talk one's way past"; c9b clause (ii) "STILL THE REAL WALL"). But `exists_factor` (`Pic0ChartOpenImmersionCriterion.lean:139-141`) is

```lean
exists_factor : ∀ (S : Scheme.{u}) (v : S ⟶ X) (w : S ⟶ T),
  f.app (op S) v = g.app (op S) w → ∃ u : S ⟶ (W : Scheme.{u}), u ≫ r = v ∧ u ≫ W.ι = w
```

— a **surjectivity** statement onto an open `W` that the datum must also supply, alongside `r` and `sq`. Your residue gives the *necessary* half (injectivity) and nothing else. `exact?` on `ChartFibrePresented C (abelSigmaChart …) g` from the residue at every `A` fails. So the residue is not weaker than `exists_factor` in the sense that matters; it is one of `exists_factor`'s consequences, and the fields `W`/`r` and the existence of `u` are untouched. Your `:305-312` disclaimer is right and the "strictly weaker in two independent ways" at `:165-171` contradicts it.

## What is safe to report to a human

- **Claim (1)** — `chartValue_eq_iff_abelDiv_eq`, twist cancels, `m`/`Z`/`hdeg` decoration for the fibre question. Sound, and stronger than you stated.
- **Claim (2)** — `abelDiv_eq_iff_forall_relPicMk_picClass_eq`. Sound. Minor: the docstring's "the curve enters only through properness and geometric integrality" is about the *proof*; the statement typechecks without `IsProper` too.
- **Claim (3)** — the composite and `not_isChartLocusFibre_of_relPicMk_picClass_eq`. Lean sound; drop the "modulo `picFromBase`, strictly easier" gloss (finding 3).
- **Claim (4)** — **do not report as a reduction.** Report it as an equivalent restatement at ring level.

## Could not settle

- **Whether the residue is TRUE for the curve at `n = g`.** That is the fork itself. Nothing in the file or my probes bears on it, and the equivalence I proved means it cannot be settled more cheaply than the fork.
- **Whether `DivFamZar C A π n` is inhabited non-degenerately for a general `A`.** `exact?` found no `Nonempty` producer, and the only route I see is through `ThetaGeneratorSeed.certifiedFamily` (`DivSchemeEps.lean:237`), which needs `hD`/`hc`. I did not chase it. This is the I-1112 carrier question, unresolved — so I cannot rule out that `Subsingleton (DivFamZar …)` is the only inhabitant of the residue *in practice*, only that it is not the only one *in principle*.

## Filed

I-1148 (nonexistent declaration), I-1149 (converse is free; `picFromBase` discount empty), I-1151 (import-closure claim scope), I-1150 (memory: a reduction whose converse you declined to measure is a renaming until you measure it).

Scratch at `/tmp/ajcr-audit/` deleted. Nothing under `AlgebraicJacobian/` touched, nothing committed.
