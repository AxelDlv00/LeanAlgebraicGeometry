All checks done and findings filed. Here is my verdict.

## Bottom line

**The claim holds.** I attacked it on all six axes and found no mathematical defect. Two real documentation defects, both filed. The task is converging fast and is honestly reported — every authoritative surface (task comments, roadmap, graph, commit messages) says "still open, one statement remains," and none contradicts it.

---

### 1. Is the gate arithmetic honest? — **PASS, verified by signature, not by prose**

I printed the three signatures rather than trusting the docstrings. `hasRigidPushforward_of_gammaBaseChange` really does carry exactly one hypothesis:

```
[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIntegral C.hom],
  (∀ (A) [CommRing A] [Algebra k A] [Algebra.FiniteType k A], RigidPushforwardGammaBaseChange C A) →
    Scheme.HasRigidPushforward C
```

The two comparison theorems carry the *identical* three instance binders plus, respectively, `[IsIntegral (p1Over k).left]` + 3 explicit (= four) and `[IsIntegral (p1Over k).left]` + 2 explicit (= three). Nothing was moved into a binder: the `IsIntegral` binder is *gone*, discharged by a real instance, and no `[HasFiniteMapToP1 C]` / `[ExistsNonconstantMapToP1 C]` / unstated class appears. **4 → 3 → 1 is honest arithmetic.**

`rigidPushforwardLocallyFree_proved` is stronger than I expected: no hypotheses at all beyond the three AJC-curve classes and the algebra data. It is a genuinely unconditional theorem.

### 2. Vacuity — **REFUTED, and this was the right thing to worry about**

`ProjectiveSpace n S = pullback (terminal.from S) (terminal.from (Proj 𝒫[n]))` is the correct construction (`S ×_ℤ Proj ℤ[Xᵢ]`), but I did not take that on faith. I killed each degenerate model from theorems already in the tree, with probes in `/tmp` against the warm oleans:

- **Empty** is impossible: `p1XSection_ne_zero` is a *theorem*, and in a subsingleton ring every element is `0`. So `Γ(ℙ¹_k, V₀)` is nontrivial ⇒ `V₀ ≠ ⊥` ⇒ ℙ¹ nonempty. I proved both in Lean; they compile.
- **A point** is impossible: `p1ChartSectionsAlgEquivX : Γ(ℙ¹_k, V₀) ≃ₐ[k] k[T]` plus `isAffineOpen_p1Chart` gives `V₀ ≅ Spec k[T] = 𝔸¹_k`. I built that iso and it typechecks.
- **𝔸¹ masquerading as ℙ¹** is impossible: `IsProper (ℙ¹ ↘ Spec k)` synthesizes independently (mathlib's `Proj.toSpecZero` properness, base-changed) and 𝔸¹ is not proper over `k`. Two proved theorems that no degenerate model satisfies simultaneously.

So `IsIntegral (ℙ¹_k)` is a statement about a genuinely proper integral curve containing an affine line. Not vacuous, not useless.

### 3. Is `RigidPushforwardGammaBaseChange` a hiding place? — **No**

- The `∃ s` cannot be gamed: `s` is an `AddMonoidHom` whose values are prescribed on simple tensors, which generate the tensor product as an abelian group, so `s` is *unique* and the content is the `Bijective s`. The file's own vacuity audit says this and it is correct.
- I checked the one thing the file's audit does *not* mention: the definition also quantifies `∀ (e' : f' ⁻¹ᵁ ⊤ ≤ g' ⁻¹ᵁ (q ⁻¹ᵁ ⊤))`, which would be a vacuity hole if that inequality were false. It is `⊤ ≤ ⊤`; `rigidPushforwardBaseChange_of_gamma` discharges it by `simp`. Inhabited, so no hole.
- `rigidPushforwardBaseChange_of_gamma` delivers the gate's pinned `Scheme.RigidPushforwardBaseChange` (`Picard/RigidPushforward.lean:342`) verbatim — I matched the five `pushforwardBaseChangeMap` arguments against §3's `f, g, f', g', comm` one by one. Not a weaker cousin.
- The leaf is also *true* at the generality asked: `hΓ` is demanded only at `Algebra.FiniteType k A` (noetherian), where `h¹ = 0` splits the two-term complex and `H⁰` commutes with **arbitrary** base change without flatness. It is a reachable target, not an unprovable placeholder.

The "Caveat, stated once and meant" paragraph (§2/§3 assume only `comm`, not cartesian) is the correct and honest framing — those theorems are exactly as strong as `hbij`.

### 4. Axioms — **all clean; here is which ones that actually means something for**

All report `[propext, Classical.choice, Quot.sound]`. Applying I-0375's caveat:

| Declaration | Real content? |
|---|---|
| `instIsIntegralP1OverLeft` | **Yes** — unconditional, concrete scheme, no gate quantified over. |
| `p1RankIdentity_proved` | **Yes** — the five hypotheses of `P1RankIdentity` are *producible* (by `p1Cech_h0_baseChange_of_fibrewise_h1_vanishing_of_isIntegral`), so it is not vacuous. |
| `rigidPushforwardLocallyFree_proved` | **Yes, and strongest** — it synthesizes `HasFiniteMapToP1 C` *in its own body*, so a sorry in that chain would surface. |
| `hasRigidPushforward_of_gammaBaseChange` | **No** — this is precisely the I-0375 case: it quantifies over a producer-less statement, so its clean check is automatic and carries no information. |

I also ran the leak probe I-0375 actually asks for: forced synthesis of the whole `ExistsNonconstantMapToP1 → HasFiniteMapToP1` chain at an arbitrary AJC curve. Clean, and `existsNonconstantMapToProjInt_of_ajc`, `existsNonconstantMapToP1_of_existsNonconstantMapToProjInt`, `hasFiniteMapToP1_of_existsNonconstantMapToP1` are individually clean. **There is no sorried gate hiding under the AJC-curve instance binders.** Zero `sorry`/`axiom`/`native_decide` in all seven files, and no `instance : HasRigidPushforward` anywhere (correctly).

Caveat: I relied on warm `.olean`s (all newer than their sources) plus `lake env lean`; I did not re-run `lake build`, so style linters were not independently re-checked.

### 5. Docstring truthfulness — **two real defects, both filed**

The `d = 0 / M₁` counterexample is **true** and correctly hedged. The `k[x]`, `M = 𝒪/x` counterexample is **true and sharp**. But:

- **`RigidPushforwardRank.lean:116` and `:477-478` overstate necessity.** The heading claims "the finiteness, projectivity **and base-change** hypotheses are load-bearing … dropped, the statement is **false**", and `:477` says "The three hypotheses that do occur are genuinely necessary". In the cited counterexample `hsurj`, `hfin` and `hbc` all **hold**; only `hproj` fails. The docstring says so itself two sentences later ("What excludes it is exactly `Module.Projective`"), so the file contradicts its own heading. This is the same class of overstatement commit `f836f8b61` set out to repair, surviving in a file that commit edited.
- **`RigidPushforwardAffineDescent.lean:148-155` ("correction 2") is a wrong recipe.** It says `surjective_moduleSectionDiffBase_baseChange_residueField` needs "four such binders (`⊤`, `U₁`, `U₂`, `U₁ ⊓ U₂`) … not the single `Algebra` binder" and tells the next session to copy it. The cited lemma has **three** `baseSectionsModule` binders (no `⊤`) **and keeps** the `Algebra` binder. This session's own WIP file already proves the recipe wrong — its `exists_chartTensorEquiv` uses one `baseSectionsModule W` binder plus the `Algebra` binder. Left uncorrected it sends the next session down a blind alley.

Corrections 1, 3 and 4 all check out against the code; line cites are exact except `P1Sheaf.lean:408-421` (the def spans 408-423 — harmless).

### 6. Convergence and the next action — **converging; the named target is right**

Yes, this is converging, and unusually honestly: no leaf was declared closed that isn't, and the session refused to write `instance : HasRigidPushforward` for a statement with no producer. That refusal is the correct call.

"One remaining statement" is the right target, and I checked for a cheaper unlock. The obvious alternative — reduce along the finite affine `π_A`, then handle `p : ℙ¹_A ⟶ Spec A` — is blocked because there is no composition/pasting API for `pushforwardBaseChangeMap`; building one is *more* work, not less. **The Γ-level route is the cheap one**, and it is cheaper than the AffineDescent docstring makes it sound: the "genuinely missing piece" is assembled from bricks that already exist (`isPushout_appLE_of_isPullback'`, `pullback_app_isoTensor_baseMap_sectionLinearEquiv`, `SectionBaseChange.bijective_addHom_of_isPushout`).

Note this: **while I was reviewing, the live session created `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RigidPushforwardChartBaseChange.lean`** (19:42) containing exactly `exists_chartTensorEquiv` and `chart_smul_baseMap_res`. I ran `lake env lean` on it: **it type-checks clean, zero sorries.** So the piece the docstring calls missing is essentially built.

**Highest-value next action:** finish and land that file — replace the placeholder docstrings (`placeholder`, `helper`, `M1`, `M2`), root it in an importer, commit it. It is currently untracked and imported by nothing, which per memory I-0362 makes it green and invisible; if this session ends abruptly the work is effectively lost. Then assemble `RigidPushforwardGammaBaseChange` by instantiating the fourth conjunct of `p1Cech_h0_baseChange_of_fibrewise_h1_vanishing_of_isIntegral` at `B := Γ(Spec A', ⊤)` and converting kernels to global sections on both sides. The residual risk there is Lean engineering, not mathematics — specifically correction 4's "motive is not type correct" congruence for moving from `π_A ≫ p` to `q`.

### Things I would not block on, but the Horizon agent should reconcile

- Roadmap node `AJC.picrep.rigidpushforward` is **titled** "gate reduced to three statements" while its own summary says "ONE statement, not four". One-line fix.
- Memory **I-0381** still lists all four leaves as "NOT proved" — stale by three leaves.
- **I-0420** (janitor) already filed the `hasRigidPushforward_of_leaves` "four named leaves … exact remaining frontier" staleness; I did not duplicate it. It is the same overstatement family as my two findings — three stale frontier claims now outstanding in this cone.
- Attribution: the four largest modules sit in the ledger under run 0054 / `ajc-truth` trailers (`515e8276a`), linked to this task only by the zero-diff record commit `3636b5ea2`. The session documented this itself; second occurrence of the sweep hazard.
- Graph `lean_status=lean_ok` is set on both `HasRigidPushforward` (a class with no instance) and `RigidPushforwardGammaBaseChange` (an unproved `def … : Prop`). It means "elaborates", not "proved" — easy to misread when budgeting.

### Filed

Two `issue` items to `task:ajc-gate` (the Rank necessity overstatement; the wrong correction-2 recipe plus the untracked WIP file), and one persistent `memory` to `horizon` recording the vacuity-refutation pattern and the three green lights that do not mean "proved" (graph `lean_ok`, gate-quantified axiom checks, instance binders), together with the one that does.

Note: the inbox is over its advisory limits (39 open non-protection, 17 open memory) — worth a janitor pass.
