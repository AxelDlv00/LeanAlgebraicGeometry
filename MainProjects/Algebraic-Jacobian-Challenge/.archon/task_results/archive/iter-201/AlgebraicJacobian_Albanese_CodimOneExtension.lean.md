# AlgebraicJacobian/Albanese/CodimOneExtension.lean — iter-201 Lane COE-Stage6.B-Jacobian

## Session summary

- Lane: **COE-Stage6.B-Jacobian** (Jacobian-regular-sequence witness + L1061
  closure), prover-mode mathlib-build.
- Built axiom-clean: **3 new project-local Mathlib substrate lemmas** for the
  iter-201+ Step A chain (Matsumura A1 + cotangent-localisation transport A2
  + assembly A3) per the `coe-stacks00sw` analogist recipe.
- Sorry count: **3 → 3** (no public-signature change; substrate-only iter).
- HARD BAR (per PROGRESS.md): "land Step A axiom-clean" — **NOT MET in full**.
  The PROGRESS-pinned A1 (Matsumura helper:
  `matsumura_isRegular_of_linearIndependent_cotangent`) requires the Mathlib
  gap `IsRegularLocalRing → IsDomain` (Stacks 00NQ) + the inductive step's
  `A / (f₁)` regular-local-ring-of-dim-(n-1) bridge, both of which are
  substantive commutative algebra gaps at Mathlib commit `b80f227`. The two
  A2 substrate sub-lemmas landed are PARTIAL — Mathlib-gap-free pieces that
  the eventual A2 closure consumes.
- PUSH-BEYOND (L1061 inline closure): NOT attempted; gated on A1 + the
  conormal-localisation iso (Stacks 02JK for `AtPrime`, separate Mathlib gap).

## Lemmas added (axiom-clean, in declaration order)

All declarations sit inside `namespace AlgebraicGeometry.Scheme` (the file's
ambient namespace), as private theorems with explicit project-local docstrings,
between the iter-200 `ringKrullDim_quotient_add_eq_of_regular_sequence`
(L807) and the iter-198
`exists_isStandardSmoothOfRelativeDimension_of_isStandardSmooth`.

### 1. `submersivePresentation_relation_cotangent_mk_linearIndependent` (L854)

**Type signature.**
```lean
private theorem submersivePresentation_relation_cotangent_mk_linearIndependent
    {R S : Type*} [CommRing R] [CommRing S] [Algebra R S]
    {ix sx : Type*} [Finite sx]
    (P : Algebra.SubmersivePresentation R S ix sx) :
    LinearIndependent S
      (fun i : sx => Algebra.Extension.Cotangent.mk
        (⟨P.relation i, P.relation_mem_ker i⟩ : P.toExtension.ker))
```

**Role.** Forward-ergonomic re-package of `P.basisCotangent.linearIndependent`
combined with `P.basisCotangent_apply`: restates the basis-form lin-indep
statement with the explicit `Cotangent.mk`-of-relation form on the consumer
side. Eliminates the need for downstream callers to manually unfold the basis
abstraction every time they want lin-indep of relation classes in I/I².

**Proof technique.** 1 `Basis.linearIndependent` + 1 funext rewrite via
`basisCotangent_apply`.

**Axiom check.** `axioms: [propext, Classical.choice, Quot.sound]` ✓

### 2. `submersivePresentation_relation_cotangent_mk_linearIndependent_localized` (L889)

**Type signature.**
```lean
private theorem submersivePresentation_relation_cotangent_mk_linearIndependent_localized
    {R S : Type*} [CommRing R] [CommRing S] [Algebra R S]
    {ix sx : Type*} [Finite sx]
    (P : Algebra.SubmersivePresentation R S ix sx)
    (p : Ideal S) [p.IsPrime] :
    LinearIndependent (Localization.AtPrime p)
      (fun i : sx =>
        (LocalizedModule.mkLinearMap p.primeCompl P.toExtension.Cotangent)
          (Algebra.Extension.Cotangent.mk
            (⟨P.relation i, P.relation_mem_ker i⟩ : P.toExtension.ker)))
```

**Role.** Transport of helper #1 through the canonical localisation map of
`P.toExtension.Cotangent` at any prime `p` of `S`. The resulting family in
`LocalizedModule p.primeCompl P.toExtension.Cotangent` is
`Localization.AtPrime p`-linearly independent. Realises Analogue D
(LinearIndependent.of_isLocalizedModule_of_isRegular variant — here using the
plain `LinearIndependent.of_isLocalizedModule` which delivers the upgraded
`Rₛ`-lin-indep over the localised base) of the `coe-stacks00sw` analogist
recipe at the un-quotiented cotangent level.

**Proof technique.** 1 invocation of `LinearIndependent.of_isLocalizedModule`
on top of #1.

**Axiom check.** `axioms: [propext, Classical.choice, Quot.sound]` ✓

**Residual A2 work:** identifying `LocalizedModule p.primeCompl P.toExtension.Cotangent`
with `(I·A)/(I·A)²` over the localisation `A = S_p`, i.e.\ Stacks 02JK's
conormal-localisation iso (for `AtPrime`, not `Localization.Away`), is a
separate Mathlib gap not landed here.

### 3. `ringKrullDim_quotient_localization_MvPolynomial_of_regular` (L924)

**Type signature.**
```lean
private theorem ringKrullDim_quotient_localization_MvPolynomial_of_regular.{v}
    {k : Type u} [Field k] {ix : Type v} [Finite ix]
    (m : Ideal (MvPolynomial ix k)) [m.IsMaximal]
    (A : Type*) [CommRing A] [Algebra (MvPolynomial ix k) A]
    [IsLocalization.AtPrime A m] [IsNoetherianRing A]
    (rs : List A) (hReg : RingTheory.Sequence.IsRegular A rs)
    {b : ℕ} (hLen : rs.length = b) :
    ringKrullDim (A ⧸ Ideal.ofList rs) + (b : WithBot ℕ∞) =
      (Nat.card ix : WithBot ℕ∞)
```

**Role.** Mathlib-gap-conditional composite chaining the iter-200 capstone
`ringKrullDim_localization_atMaximal_MvPolynomial` (Step 1+2, polynomial-ring
side Krull dimension) with the iter-200
`ringKrullDim_quotient_add_eq_of_regular_sequence` (Step 3 additive form,
regular-sequence dimension drop). Given an `IsRegular A rs` witness (the
substantive iter-201+ Step A obligation, currently a Mathlib gap), this
lemma reduces the `ringKrullDim S_m = n` conclusion of Stacks 00OE to a
one-line invocation: once Step A lands axiom-clean upstream, the iter-200
Step 3 endpoint is immediately consumable here.

**Proof technique.** Trivial `IsLocalization.AtPrime.isLocalRing` instance
attachment + 1 invocation of the iter-200 Step 3 additive form. The
substantive content was already in the iter-200 substrate; this lemma
just packages it for direct A3 consumption at the polynomial-ring setting.

**Axiom check.** `axioms: [propext, Classical.choice, Quot.sound]` ✓

## Summary

- **Declarations added:** 3 axiom-clean private theorems (L854, L889, L924),
  totaling ~95 LOC including docstrings.
- **Declarations blocked:** the full PROGRESS-pinned Step A (A1 + A2 + A3)
  was not landed — A1's `matsumura_isRegular_of_linearIndependent_cotangent`
  is gated on `IsRegularLocalRing → IsDomain` (Stacks 00NQ) and the inductive
  `A / (f₁)` regular-local-ring-of-dim-(n-1) bridge, both substantive Mathlib
  gaps at commit `b80f227` that materially expand the project's commutative
  algebra debt.
- **Sorry count:** 3 → 3 (L1061: `isRegularLocalRing_stalk_of_smooth`;
  L1305 / L1373: `extend_of_codimOneFree_of_smooth` /
  `indeterminacy_pure_codim_one_into_grpScheme`).
- **Compile status:** GREEN (no errors; 3 pre-existing sorry warnings).

## Why I stopped

**Partial progress on the PROGRESS-pinned HARD BAR.** The 3 axiom-clean
substrate lemmas landed this iter cover (a) the cotangent-side lin-indep
forward ergonomics (#1) and (b) the polynomial-ring side Step A2 transport
through a generic localisation map (#2), and (c) the Mathlib-gap-conditional
Steps 1+2+3 composite at the polynomial-ring setting (#3). These collectively
narrow the iter-201+ residual to the substantive A1 (Matsumura) closure plus
the conormal-localisation iso for `AtPrime` (the residual A2 work).

**A1 (Matsumura helper) was scouted but not attempted in full.** Scouting via
`lean_local_search` + `lean_leansearch` + grep across Mathlib `b80f227`:

* `IsRegularLocalRing → IsDomain` (Stacks 00NQ): the only `IsRegularLocalRing`
  instance in Mathlib is `[IsLocalRing R] [IsDomain R] [IsPrincipalIdealRing R]
  → IsRegularLocalRing R` (the *PID converse*); the forward direction
  "regular local ⇒ domain" is absent.
* `A ⧸ (f₁) → IsRegularLocalRing of dim n-1`: also absent. Mathlib has
  `ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim` (dim drops by
  1 under `IsSMulRegular`), but no preservation-of-RLR lemma.

Both gaps are substantive: Stacks 00NQ's standard proof goes through
associated-primes / Cohen-Macaulay theory, which is itself partially
infrastructure-dependent in Mathlib. Closing A1 axiom-clean would have
required either a ~200--300 LOC Mathlib-side build of the Stacks-00NQ
chain, or an alternative project-side route that I did not identify in
this iter's scouting.

**Informal-agent consultation skipped:** no `DEEPSEEK_API_KEY` /
`MOONSHOT_API_KEY` / `OPENROUTER_API_KEY` / `OPENAI_API_KEY` /
`GEMINI_API_KEY` was set in environment, so the
`.claude/tools/archon-informal-agent.py` fallback was not available. This is
documented per the protocol.

**Approaches written but not attempted:** none in scope this iter. The
A1-with-IsDomain-hypothesis variant was briefly considered but rejected
because the *inductive step* still needs `A / (f₁)`-side regular-local-ring
structure, and the iter-201 task scope does not extend to building that
preservation lemma.

**Push-beyond (L1061 inline closure) NOT attempted.** Even with the full
Step A in hand, the L1061 closure path requires (i) the scheme-to-algebra
bridge extracting a SubmersivePresentation from
`Algebra.IsStandardSmoothOfRelativeDimension Γ(Spec, U) Γ(X.left, V)`,
(ii) the conormal-localisation iso for `AtPrime`, and (iii) chained algebra
isos `Γ(Spec(.of kbar), U) = kbar` etc. The chain has multiple Mathlib gaps
beyond the Step A obligation.

## Dead-end warnings (for the planner)

- **Do NOT attempt A1 (Matsumura helper) without first building
  `IsRegularLocalRing → IsDomain`** (Stacks 00NQ) as a project-local
  prerequisite. The Mathlib gap is hard: Stacks 00NQ's standard proof
  uses Cohen-Macaulay / depth theory, which itself is missing the deeper
  Auslander–Buchsbaum bridges (cf. the parallel Lane AB iter-201 state).
- **Do NOT pursue the conormal-localisation iso for general AtPrime
  primes** (the residual A2 work after #2 above) without first verifying
  that Mathlib's `Algebra.Generators.cotangentCompLocalizationAwayEquiv`
  generalises to a not-necessarily-Away localisation. The Mathlib gap may
  be partial.
- **Do NOT rephrase #3** in a subtraction form. Per the iter-200
  dead-end warning (carried over), `WithBot ℕ∞` carries no `HSub`
  instance; the additive form is the natural API.

## Next step (iter-202+)

1. **Build `IsRegularLocalRing → IsDomain` (Stacks 00NQ)** as a project-side
   substrate, OR scout for an upstream Mathlib PR that may have landed
   between commits. Estimated 100--200 LOC if built locally.
2. **Build the `A / (f₁)`-regular-local-ring-of-dim-(n-1) bridge**
   (essentially Stacks 00NQ inductive step). Estimated 100--200 LOC.
3. **Once 1 + 2 land, A1 collapses** to ~30--50 LOC induction following
   the `coe-stacks00sw` recipe. A2's residual (conormal-localisation
   iso for `AtPrime`) is a separate ~80--120 LOC build. A3 is a
   ~10-LOC composition.
4. **Push-beyond L1061**: still gated on the above + scheme-to-algebra
   bridging.
5. **Alternative**: pivot to a closed-point regularity chain via
   `IsRegularLocalRing.localization`, since the L1061 consumer wants
   regularity at a codim-1 stalk (descending from a closed-point witness
   via Stacks 00OF). But Mathlib `b80f227` lacks
   `IsRegularLocalRing.localization` (verified by grep over the whole
   `Mathlib/RingTheory/RegularLocalRing/` directory — only `Defs.lean`,
   no other files). So this route is also blocked.

## Mathlib readiness audit (iter-201 actual API state at b80f227)

Confirmed EXISTS during this iter's substrate build:
* `Algebra.SubmersivePresentation.basisCotangent`
  (`Mathlib/RingTheory/Smooth/StandardSmoothCotangent.lean:143`)
* `Algebra.SubmersivePresentation.basisCotangent_apply` (L146)
* `Algebra.SubmersivePresentation.cotangentEquiv` (L127)
* `Basis.linearIndependent` (`Mathlib/LinearAlgebra/Basis/Basic.lean:86`)
* `LinearIndependent.of_isLocalizedModule`
  (`Mathlib/RingTheory/Localization/Module.lean`)
* `LocalizedModule.mkLinearMap` + canonical `IsLocalizedModule` instance
* `Localization.AtPrime` + `IsLocalization.AtPrime.isLocalRing`
* `IsWeaklyRegular.isRegular_of_isLocalizedModule_of_mem`
  (`Mathlib/RingTheory/Regular/Flat.lean:65`)
* `IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal`
  (`Mathlib/RingTheory/Regular/RegularSequence.lean:510`)
* `ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim`
  (`Mathlib/RingTheory/KrullDimension/Regular.lean`)
* `RingTheory.Sequence.isRegular_cons_iff` (RegularSequence.lean:246)

Confirmed MISSING in Mathlib at `b80f227`:
* `IsRegularLocalRing → IsDomain` (Stacks 00NQ) — the substantive A1 gap.
* `A / (f₁) → IsRegularLocalRing` preservation (the A1 inductive step gap).
* `IsRegularLocalRing.localization` (Stacks 00OF) — needed for the
  alternative closed-point + 00OF route.
* `Algebra.Generators.Cotangent.tensor` / conormal-localisation iso for
  `IsLocalization.AtPrime` (Stacks 02JK at a non-Away prime) — the
  substantive residual A2 gap.

## Blueprint pin handoff to review agent

The new substrate lemmas are project-local `private` declarations, not
exposed for downstream consumption outside `CodimOneExtension.lean`. They
support the existing blueprint pin `lem:smooth_to_regular_local_ring`
(L1061 sorry) at the substrate level.

The blueprint chapter `Albanese_CodimOneExtension.tex` already pins the
iter-201 recipe in `\subsec:stage6_iib_substrate_iter200` (per the
iter-201 plan agent's expansion). The new substrate lemmas (#1, #2, #3)
correspond to Step A2 sub-substrates and Step 1+2+3 composite in that
recipe; the substantive residual (Step A1 Matsumura helper) remains the
binding iter-202+ obligation.

**Review-agent action items for iter-201 chapter sync:**

* Recommend NOT marking `lem:smooth_to_regular_local_ring` with `\leanok`
  — the L1061 sorry remains; the substrate lemmas built this iter narrow
  the remaining content but do not close the proof body.
* Recommend ADDING new `\lean{...}` pins to the chapter pointing at the 3
  new axiom-clean substrate lemmas:
  - `AlgebraicGeometry.Scheme.submersivePresentation_relation_cotangent_mk_linearIndependent`
  - `AlgebraicGeometry.Scheme.submersivePresentation_relation_cotangent_mk_linearIndependent_localized`
  - `AlgebraicGeometry.Scheme.ringKrullDim_quotient_localization_MvPolynomial_of_regular`
* The substrate is forward-compatible: any future iter-202+ A1 closure
  (whether via the Matsumura route or an alternative) can compose with
  these three to produce the Step A endpoint.
