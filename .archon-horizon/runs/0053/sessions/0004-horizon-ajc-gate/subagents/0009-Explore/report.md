Verified against the code. Compact verdicts below.

---

## (A) `RigidPushforwardRank.lean`

**A1. The two counterexample paragraphs (exact text).**

Module docstring, lines 116–128 (`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RigidPushforwardRank.lean`):

> ## Why the finiteness, projectivity and base-change hypotheses are load-bearing
>
> They are not decoration: dropped, the statement is **false**, and its
> consumers become vacuous.  The counterexample recorded at
> `Picard/RigidPushforwardP1Sheaf.lean`:567-576 is `A = k[x]` with
> `M = 𝒪_{ℙ¹_A}/x = coker(𝒪 --x--> 𝒪)`, which is finitely presented.  Then
> `Γ(ℙ¹_A, M) = A/(x) = k` is a *torsion* `A`-module, so `Module.rankAtStalk` at
> `t = (x)` takes its junk value `0`; but the fibre is `ℙ¹_k` with
> `M_t = 𝒪_{ℙ¹_k}`, so `p.fiberH0 M t = 1`.  What excludes it is exactly
> `Module.Projective` — `k` is not a projective `k[x]`-module — which is the
> hypothesis that licenses `Module.rankAtStalk_eq` in step 2.  `Module.Finite` is
> needed by the same lemma, and the `kerBaseChange` bijectivity is what makes
> step 3 an isomorphism rather than a one-way comparison map.

And the `d = 0` counterexample, lines 100–110:

> * `rank_pushforward_eq_fiberH0` **does not use surjectivity of `d`**.  The
>   `hsurj` argument of `P1RankIdentity` is consequently unused in
>   `p1RankIdentity_proved`.  It is *not* implied by the other hypotheses —
>   do not delete it from a downstream statement on that reading.  (Take
>   `d = 0 : M₀ →ₗ M₁` with `M₁ ≠ 0` flat: then `ker d = M₀`, `d.baseChange B = 0`,
>   and `kerBaseChange d B` is the identity of `B ⊗ M₀`, bijective for every `B`,
>   while `d` is not surjective.)  The accurate claim is only that this proof
>   does not need it. …

**A2. The declarations.**
- `Adelic.P1RankIdentity` — defined at `.../Picard/RigidPushforwardP1Sheaf.lean:584-618`. It is `∀ M, M.IsFinitePresentation → hsurj → hfin → hproj → hbc → ∀ t, sectionsRankAtStalk ((Modules.pushforward (pullback.snd …)).obj M) t = (pullback.snd …).fiberH0 M t`, with the three `letI := ….baseSectionsModule M ·` binders (`U₁`, `U₂`, `U₁ ⊓ U₂`).
- `Adelic.p1RankIdentity_proved` — `.../Picard/RigidPushforwardRank.lean:619-625`, a five-line `intro`/`exact` onto `rank_pushforward_eq_fiberH0` (`RigidPushforwardRank.lean:481`). No `sorry` in the file.
- `sectionsRankAtStalk` = `Module.rankAtStalk Γ(N, ⊤) t` (`P1Sheaf.lean:317-319`), so the counterexample's `Module.rankAtStalk` really is the LHS.

**A3. Is the counterexample correct? — TRUE, and in fact *sharper* than stated.**
- Line-cite `P1Sheaf.lean:567-576` is exact (the paragraph occupies precisely 567–576).
- Math checks out: with `A = k[x]`, `M = 𝒪/x`, the Čech data is `k[t] ⊕ k[t] → k[t,t⁻¹]`, `ker d = Γ(ℙ¹_A,M) = k`; over `R_{(x)} = k[x]_{(x)}` the module `k` is torsion so `Module.rank = 0`, hence `rankAtStalk = 0`, while the fibre at `(x)` is `ℙ¹_k` with `M_t = 𝒪`, `fiberH0 = 1`. `M` is finitely presented, so it is a genuine counterexample to the conclusion once the engine hypotheses are dropped.
- Which hypotheses it violates: I checked all four. `hsurj` **holds** (`H¹(ℙ¹_k,𝒪)=0`); `hfin` **holds** (`k` is cyclic over `k[x]`); `hbc` **holds** — everything in the complex is killed by `x`, so for any `k[x]`-algebra `B` both `B ⊗_A ker d` and `ker(d ⊗ B)` are `B/xB` and `kerBaseChange` is the canonical iso. Only `hproj` fails. So the sentence "What excludes it is exactly `Module.Projective`" is **correct and precise**.
- Consequence / mismatch to flag: the *section heading* and lead sentence overstate. "Why the finiteness, projectivity **and base-change** hypotheses are load-bearing … dropped, the statement is **false**" is established by this example for `hproj` only; the example is consistent with `hfin` and `hbc`. Same overstatement, more sharply, in the `rank_pushforward_eq_fiberH0` docstring, `RigidPushforwardRank.lean:477-478`: "The three hypotheses that do occur are genuinely necessary; see the module docstring for the counterexample that drops `hproj`." — "genuinely necessary" is asserted for three hypotheses but witnessed for one. Verdict: **PARTLY** (the counterexample itself is right; the surrounding necessity claim is broader than the evidence).
- The `d = 0`, `M₁ ≠ 0` flat example (lines 103–106) is **TRUE** as linear algebra: `ker d = ⊤`, `kerBaseChange d B` is the base change of `(⊤ : Submodule).subtype`, hence bijective for every `B`, and `d` is not surjective. Minor caveat: it shows non-implication for *abstract* `d`, not for `d` of the form `𝒰.moduleSectionDiffBase`; the text's own hedge ("The accurate claim is only that this proof does not need it") covers this.
- Consistency check of the pairing: `P1RankIdentity`'s own docstring (`P1Sheaf.lean:562`) lists "`d` surjective" among the engine hypotheses, while `p1RankIdentity_proved` never uses `hsurj` — the Rank docstring says so explicitly, so the two files agree.

**A4. Full hypothesis list of `p1RankIdentity_proved`.**
```
theorem p1RankIdentity_proved (A : Type u) [CommRing A] [Algebra k A] : P1RankIdentity k A
```
with section context `variable {k : Type u} [Field k]` (`RigidPushforwardRank.lean:607`). Complete list: `{k : Type u}`, `[Field k]`, `(A : Type u)`, `[CommRing A]`, `[Algebra k A]`. Nothing else — no `[Algebra.FiniteType k A]`, no `[IsIntegral ((p1Over k).left)]`, no `[Noetherian]`, no properness.

Claim verdict: **TRUE, literally.** The gate does quantify over FiniteType — `Frontier.lean:185-186`: `(hrank : ∀ (A : Type u) [CommRing A] [Algebra k A] [Algebra.FiniteType k A], P1RankIdentity k A)` — and `p1RankIdentity_proved` supplies it for every `k`-algebra, so it strictly over-satisfies the gate. Consistency: `rank_pushforward_eq_fiberH0`'s instance arguments are exactly `[M.IsQuasicoherent] [QuasiCompact p] [QuasiSeparated p] [IsAffineHom (p.fiberι t)]`, matching the docstring's line 111-114 list verbatim (finite presentation of `M` is consumed in the ℙ¹ specialization only to produce quasicoherence, via `haveI := hfp`).

---

## (B) `RigidPushforwardAffineDescent.lean` — four corrections (lines 130–174)

**Correction 1 (lines 136–146) — TRUE.**
- `TwoTermFiniteFree.lean:392` is exactly `theorem bijective_kerBaseChange_of_surjective [Module.Flat A M1] {d : M0 →ₗ[A] M1} (hd : Function.Surjective d) …`. `M1` is the codomain of `d`; for `d = 𝒰.moduleSectionDiffBase f M` (`RigidPushforwardP1Engine.lean:186-191`) the codomain is `Γ(M, U₁ ⊓ U₂)`. So "also demands `Module.Flat Γ(Spec A, ⊤) Γ(M, U₁ ⊓ U₂)`" is exactly right.
- `RigidPushforwardP1Constants.lean:540-544` is exactly the fourth conjunct of `p1Cech_h0_baseChange_of_fibrewise_h1_vanishing_of_isIntegral` (theorem at line 509), and it reads `∀ (B : Type u) [CommRing B] [Algebra Γ(Spec (CommRingCat.of A), ⊤) B], Function.Bijective (AlgebraicJacobian.TwoTerm.kerBaseChange (…) B)` — every algebra `B`, as claimed. Line range exact.
- Context caveat (not an error): that theorem also carries `[IsIntegral ((p1Over k).left)]`, `[Algebra.FiniteType k A]`, `[M.IsFinitePresentation]`, `hflat`, and the `_hfib` fibrewise-surjectivity argument, so "instantiate `B`" is free only after those are in hand.

**Correction 2 (lines 148–155) — PARTLY (one false detail).**
`RigidPushforwardFiberChart.lean:508-518` is the right declaration and the range is exact (508 = theorem line, 518 = last line of statement). But its binder list is:
```
letI : Algebra Γ(Y, ⊤) Γ(Spec (Y.residueField t), ⊤) := ((Y.fromSpecResidueField t).appLE ⊤ ⊤ le_top).hom.toAlgebra
letI := f.baseSectionsModule M 𝒰.U₁
letI := f.baseSectionsModule M 𝒰.U₂
letI := f.baseSectionsModule M (𝒰.U₁ ⊓ 𝒰.U₂)
```
i.e. **three** `f.baseSectionsModule M ·` binders (`U₁`, `U₂`, `U₁ ⊓ U₂`), not four — there is no `⊤` binder. Also the sentence "…are required, **not** the single `Algebra Γ(Y,⊤) Γ(Y',⊤)` binder" is misleading about the model it points at: that lemma keeps the `Algebra` binder *as well as* the module binders. So the quoted words

> "four such binders (`⊤`, `U₁`, `U₂`, `U₁ ⊓ U₂`) are required, not the single `Algebra Γ(Y,⊤) Γ(Y',⊤)` binder.  Copy the binder list of `surjective_moduleSectionDiffBase_baseChange_residueField`"

do not describe the cited binder list. (The `⊤` binder may well be needed by the *intended* Γ-level statement — `moduleSectionDiffBase` itself only needs the three — but the instruction "copy the binder list" then yields three-plus-Algebra, not four.)

**Correction 3 (lines 157–165) — TRUE.**
`RigidPushforwardP1Sheaf.lean:408` is `noncomputable def pushforwardTopEquivBaseSections`; its body (411–423) is `toFun := fun x => x`, `invFun := fun x => x`, `map_add' := fun _ _ => rfl`, `left_inv`/`right_inv` `rfl` — identity on carriers — and `map_smul'` is proved by `have h : p.appLE ⊤ ⊤ le_top = p.app ⊤ := Scheme.Hom.appLE_eq_app p` then `congrArg … h.symm`. Both claims confirmed. Cited range 408-421 clips the final two `rfl` fields (def ends at 423); off-by-two, right declaration.

**Correction 4 (lines 167–173) — TRUE.**
`RigidPushforward.lean:595` is `lemma finiteMapToP1BaseChange_snd [HasFiniteMapToP1 C] : finiteMapToP1BaseChange A C ≫ pullback.snd (p1Over k).hom … = pullback.snd C.hom …`, proved at line 599 by exactly `(pullback.lift_snd _ _ _).trans (Category.comp_id _)`. Line cite is the `lemma` line itself; exact. (It is `@[reassoc (attr := simp)]`, which the note doesn't mention but doesn't contradict.) The "module structures sit inside the *type* of `moduleSectionDiffBase`" remark is corroborated by `RigidPushforwardP1Engine.lean:186-191`, whose type is under three `letI`s.

---

## Line-number accuracy summary
| Citation | Actual | Verdict |
|---|---|---|
| `P1Sheaf.lean:567-576` (counterexample) | 567–576 | exact |
| `TwoTermFiniteFree.lean:392` | 392 | exact |
| `P1Constants.lean:540-544` | 540–544 | exact |
| `FiberChart.lean:508-518` | 508–518 | exact range, but content claim wrong (see B2) |
| `P1Sheaf.lean:408-421` | def spans 408–423 | off by 2, right decl |
| `RigidPushforward.lean:595` | 595 (proof at 599) | exact |

Only two substantive problems found: the B2 "four `baseSectionsModule` binders" claim (there are three), and the A3 over-generalization from a `hproj`-only counterexample to "the finiteness, projectivity and base-change hypotheses" / "the three hypotheses … are genuinely necessary".
