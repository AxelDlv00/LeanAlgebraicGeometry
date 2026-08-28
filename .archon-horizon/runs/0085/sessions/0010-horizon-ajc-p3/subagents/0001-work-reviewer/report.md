You are auditing ONE new Lean file with FRESH CONTEXT, adversarially. Do not trust its docstrings.

FILE: /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Curve/GaloisLevelRationalPoint.lean
PROJECT ROOT (run lake from here): /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge
Oleans are current: `lake build AlgebraicJacobian.Curve.GaloisLevelRationalPoint` exits 0. IMPORTANT: if you get "object file ... does not exist" or "imports are out of date", run `lake build AlgebraicJacobian.Curve.GaloisLevelRationalPoint` FIRST — otherwise every probe reports spurious success (a known trap in this workspace).

Use `env -u GIT_INDEX_FILE lake env lean <scratch.lean>` in /tmp for probes. Do NOT edit any file in the project. Do NOT commit anything.

CONTEXT. This project's entire Jacobian tower rests on one bare `sorry`, `AlgebraicGeometry.Scheme.fgaPicardRepresentability` (Picard/FGAPicRepresentability.lean). A 2026-07-29 audit of 101 representability claims in this workspace refuted 99: 67 were sorry-reachable, 17 VACUOUS, 12 proved something adjacent to what they claimed, 3 did not exist. Assume this file is one of those until you show otherwise.

The file claims: for a smooth geometrically irreducible curve C over an ARBITRARY field k, there exists a finite GALOIS extension k''/k inside the separable closure such that the base-changed curve C_{k''} has a k''-rational point — with NO hypothesis assuming a rational point anywhere, and no antecedent beyond the curve's own typeclass binders.

AUDIT THESE SPECIFIC TARGETS. For each, report CONFIRMED-OK or REFUTED with the probe that shows it:

1. VACUITY OF THE CONCLUSION. Is `Scheme.HasRationalPoint (Scheme.baseChangeField C k'')` actually saying a point exists, or could it be satisfied trivially? Unfold `Scheme.HasRationalPoint` (Picard/FGAPicRepresentability.lean, ~line 202) and `Scheme.baseChangeField` (RiemannRoch/CurveBaseChange.lean, ~line 250). Is there any k'' for which it is degenerate? Critically: is the existential over k'' satisfiable by a DEGENERATE choice — e.g. could k'' = k = bot always work and make the statement empty of content?

2. SELF-PROJECTION. Does any proof discharge its obligation by projecting a hypothesis it assumed (the `P → P` pattern)? Especially: `exists_finiteGalois_level_hasRationalPoint` takes a k^s-point `p` with equation `hp`, and concludes a rational point elsewhere. Is that a genuine transport or a repackaging? And do the two "unconditional" theorems really discharge `hp`, or do they smuggle it back?

3. IS THE GALOIS CLAIM REAL? The file's whole selling point over its sibling `Curve/FiniteLevelRationalPoint.lean` is `[IsGalois k k'']` instead of `Algebra.IsSeparable k k'`. Verify `IsGalois k (normalClosure k k' (SeparableClosure k))` is actually what is concluded and is not weaker/different than advertised. Is `IsGalois` here mathlib's real Galois condition?

4. THE NON-VACUITY SECTION (§4, namespace AlgebraicJacobian.NonVacuity). `galoisLevel_p1Over_rat` claims P^1 over Q is a concrete inhabitant. Is it? Does `p1Over ℚ` really satisfy the binders, and does the theorem really apply to it, or is the instance resolution finding something else? `galoisLevel_at_headline_binders` claims to match `picardJacobianWitness` (Jacobian.lean:840) — compare the two binder lists yourself and say whether the match claim is accurate.

5. AXIOM CLEANLINESS, verified independently. `#print axioms` every declaration in the file. Any `sorryAx` refutes the file. Use `fgaPicardRepresentability` as a CONTROL in the same probe — it must show sorryAx, otherwise your probe environment is broken and the results mean nothing.

6. DOCSTRING CLAIMS vs REALITY. `#check` (do NOT grep) every declaration name the file's docstrings cite, inside the file's own import closure. Report any that do not resolve. Several sibling files in this project were caught advertising names that do not exist.

7. UNUSED HYPOTHESES. Does any theorem carry a binder its proof never consumes? The file itself claims `[SmoothOfRelativeDimension 1]` is unnecessary for §2 and offers a `LocallyOfFiniteType` version. Check whether the file also carries binders it does not use ANYWHERE — including in §4, where `galoisLevel_at_headline_binders` deliberately carries `[IsProper C.hom]`. Is the file's own statement about that honest?

8. THE OVERCLAIM CHECK. The file says it does NOT close the seam sorry, does NOT close campaign G1, and has an existentially-quantified level a consumer may trip on. Are those disclaimers accurate, or does some sentence elsewhere in the file contradict them? Quote any sentence that overclaims.

Report concisely and concretely: for each of the 8 targets, the verdict and the evidence. If you find nothing wrong on a target, say so plainly — do not manufacture findings. Rank anything you do find by whether it would change what a downstream lane does.
