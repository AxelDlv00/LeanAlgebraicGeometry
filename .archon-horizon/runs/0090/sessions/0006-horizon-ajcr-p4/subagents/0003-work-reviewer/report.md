Adversarially audit ONE new file in the Lean project at /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild:

  AlgebraicJacobian/Picard/JacobianDataQcFromRep.lean

authored this session by lane ajcr-p4 (commits d320d1ee20, 2cb93abba1, 84c704a279). It is rooted at AlgebraicJacobian.lean. It claims to reprice the `quasiCompact` field of `AlgebraicGeometry.JacobianData` (AlgebraicJacobian/Picard/JacobianData.lean:87-100).

Verify with `lake env lean <file>` and `#print axioms` in a scratch file. IMPORTANT: run `lake build AlgebraicJacobian.Picard.JacobianDataQcFromRep` FIRST — a scratch file importing it fails with "object file does not exist" if the olean is stale, and a stale-import state makes probes report false successes. Use a control declaration (`AlgebraicGeometry.Jacobian`, which is a `sorry`) to confirm sorryAx IS reachable in your probe's import closure. Delete any scratch file you create.

THE CLAIMS TO ATTACK, in descending order of how much they'd matter if false:

C1. "The Abel morphism is not a construction the tree owes: `abelOfPic0Class rep lam := rep.homEquiv.symm lam` IS the `abel : DivScheme … ⟶ J.left` that `JacobianData.ofAbelImage` / `ofAbelLifts` (Picard/JacobianDataAbelImage.lean:119/159, Picard/JacobianDataAbelSurj.lean:149/193) take as an unproduced hypothesis." — Is the carrier ACTUALLY the same? `divSchemeOver k A B g r₁ r₂ b₁ b₂` vs `DivScheme k A B g r₁ r₂ b₁ b₂`: check `.left` really is `DivScheme` (by rfl or not), and check the file's own `abelOfPic0Class_left` is not a tautology dressed as content.

C2. "The compatibility square is FREE at this abel, so the recorded I-0525 'groups agree ≠ maps agree' gap does not arise." — Read `IsAbelClassifyCompatible` (Picard/JacobianDataAbelSquare.lean:147) and compare with `abelOfPic0Class_comp_class` / `comp_abelOfPic0Class_eq_testPoint`. Is the file's claim scoped correctly, or does it overclaim that the general square is discharged? Is `Equiv.injective` doing real work, or is this `P → P` (projecting an assumed hypothesis)?

C3. "The splitting-field descent that Picard/JacobianDataAbelEffectivePoint.lean:44-48 and Picard/JacobianDataAbelSquare.lean:80-83 both name as the honest residue is NOT owed by the qc field" — via `quasiCompact_of_extensionTolerant_lift`. Is the extension-tolerant hypothesis genuinely WEAKER than the κ(y)-pinned one, or is it equivalent/stronger? Does the file's own scoping paragraph ("hlift as literally typed in ofAbelLifts does still want Spec κ(y)") correctly limit the claim?

C4. "`lam` is PRODUCED, not assumed: `lamOfDivRep` builds it from the chart layer's own `divRep` via `chartValueTrans` (Picard/Pic0AtlasFromDivRep.lean:176), so the qc field costs ONE open statement (`hcl`)." — Check `lamOfDivRep` typechecks for the reason claimed, and critically: does `quasiCompact_of_divRep_of_lift` require `divRep` to represent `divFunctor` at the SAME carrier `divSchemeOver k A B g r₁ r₂ b₁ b₂` that `lam` must live on, and is that carrier what the divisor-representability lane actually produces? (Compare Picard/DivRepGlobalClassify.lean.)

C5. VACUITY. Is `hcl` (the surviving hypothesis) falsifiable and inhabitable? The file claims `compactSpace_of_pic0_class_surjective` shows it implies `CompactSpace J.left` hence is refutable. Check that. Also check the degenerate case: at `J.left` EMPTY is everything free, and does that make the theorem vacuous or merely degenerate?

C6. Any claim in the docstrings that cites a declaration by name — `#check` EVERY cited constant from INSIDE this file's import closure, not by grep. Prior lanes here have three times cited names that exist in source but are outside the citing file's imports. Report any that fail.

Report: per claim, CONFIRMED / OVERCLAIMED / REFUTED, with file:line and the exact probe you ran. Be specific about anything that is true-but-trivial. At most 50 lines.
