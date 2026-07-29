You are reviewing the last two commits of the AJCR Wave-5 tangent lane (task ajcr-w5-av) with fresh context. Be adversarial: the value you add is finding what the author's own verification missed.

REPO: /home/axel/LeanAlgebraicGeometry-Horizon, project at MainProjects/Algebraic-Jacobian-Challenge-Rebuild.
Ledger git: use `git --git-dir=/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/vcs/workspace.git --work-tree=/home/axel/LeanAlgebraicGeometry-Horizon <cmd>`.

COMMITS: 33f71cf06 (worksheet only) and 4b3f46153 (module + worksheets + root import).
Note: AlgebraicJacobian/Tangent/EpsReductionSquare.lean was landed byte-identically but inside ANOTHER run's sweep commit a6d948c7e, not by this lane — verify its content at HEAD.

FILES TO REVIEW:
 1. AlgebraicJacobian/Tangent/EpsReductionSquare.lean
 2. AlgebraicJacobian/Tangent/EpsChartTrivialInstance.lean
 3. informal/w5-t4-worksheet.md sections 8.0, 8.1, 8.2, 8.3 (near end of file)
 4. informal/w5-s-worksheet.md section 3.2 and the struck sentence in 3.1

THE FIVE CHECKS I MOST WANT, in priority order:

(A) IS ANY HEADLINE VACUOUS OR WEAKER THAN ITS DOCSTRING CLAIMS? Especially:
    - `Over.appLE_dualNumberSections` claims to be "worksheet 7.8's section equation". Read 7.8 (same file, search "### 7.8") and judge whether the landed statement really is the equation 7.8 quoted, or a weaker/differently-shaped cousin. 7.8 quotes the goal as
      `(relCurve C k).resHom ⋯ ((relCurveMap C k[ε] k).appLE … (dualNumberSections C … u)) = collapseUnits C (U₀ ⊓ U₁) hci hqi (unitsFst u)`.
      The landed version has EXTRA binders (V', e, hle). Does adding them weaken it, or is it genuinely more general? Could a consumer instantiate it at the opens 7.8 needed?
    - `chartTrivial_of_map_eq_one` claims to discharge `hchart` for `twoChartKernelEquiv` (in Tangent/TwoChartKernelComparison.lean). Compare the two statements CAREFULLY. twoChartKernelEquiv wants
      `hchart : ∀ L, CechPic.map f L = 1 → ∀ s : Bool, CechPic.map (V s).ι L = 1`.
      Does the landed per-chart lemma actually supply that at the Wave-5 instance, or is there a gap (e.g. the cover family V vs the single open, or hypotheses hO/hgO that nothing produces)? THIS IS THE CHECK I MOST WANT — I claim it "discharges hchart" and I did NOT instantiate twoChartKernelEquiv.
    - `overlapQuotCongr` and `epsFamilyEq`: is either trivially true in a way that makes it useless (e.g. does overlapQuotCongr say something is equivalent to itself)?

(B) DO THE hO/hgO HYPOTHESES OF chartTrivial_of_map_eq_one HAVE PRODUCERS? They assert affineness of `fst_{k[ε]} ⁻¹ᵁ W` and of `relCurveMap ⁻¹ᵁ fst_{k[ε]} ⁻¹ᵁ W`. Search the project (use `/home/axel/.archon-env/bin/horizon search "<words>" --json`, and grep) for anything that produces affineness of those base-changed opens. If nothing does, the lemma may be unusable in practice — say so. Per inbox I-0688: every explicit binder needs a producer.

(C) ARE THE WORKSHEET'S FACTUAL CLAIMS TRUE? Specifically:
    - 8.0 claims `relCurveMap C k[ε] k ⁻¹ᵁ ((fst C (overSpec k k[ε])).left ⁻¹ᵁ W) = (fst C (overSpec k k)).left ⁻¹ᵁ W` is NOT provable by `rfl`. Verify this yourself with a probe (write a scratch file matching /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/.gitignore's ignored patterns, e.g. `scratch_review_probe.lean` at the project root — note `*probe*.lean` is gitignored — and run `lake env lean` on it from the project root).
    - 8.2 claims the hchart producer had exactly FOUR external occurrences, ALL PROSE, and that eight named declarations had ZERO external consumers. Re-run those greps at HEAD and report the real numbers. Note commit 4b3f46153 has since ADDED a consumer for some of them, so measure both at HEAD and reason about what the claim was about.
    - 8.3 claims a `rw` chain was a "silent no-op with no error reported" under a `▸`-based transport. This is a strong claim about Lean's behaviour. If you can cheaply test it (define the ▸ version in a probe and try the rw), do; if not, say it is unverified.

(D) IS THE s-worksheet's 3.2 CORRECTION SOUND? It relies on ajc-pic0av's argument that the "orbit condition" is contradictory for g ≥ 1 (translations are homeomorphisms, identity point closed, so every point closed, T1 + sober ⟹ Krull dim 0). Judge the ARGUMENT on its merits — is it actually valid? And separately: is the retraction of "X2 meets hcov" correct, i.e. does AbelianVariety/Translation.lean in fact NOT give the covering claim?

(E) ANYTHING ELSE DISHONEST OR OVERSTATED in the two modules' docstrings or the worksheet sections. I have a documented habit in this lane of hedged-then-absolute phrasing: a caveat added in one place while a flatly stronger claim two lines up survives. Look for it.

VERIFICATION AVAILABLE: `cd <project>; lake env lean <file>` works and needs no lock (takes several minutes; the box is under heavy load — be patient, and prefer ONE probe file with several `example`s over many runs). The lean-lsp MCP may time out on these imports; if it does, say so rather than treating the timeout as a failure of the proof.

REPORT: a short prioritized list. For each finding: what is wrong, the evidence (command + output, or file:line), and whether it is (i) a false claim needing retraction, (ii) an overstatement needing softening, or (iii) fine. If you find nothing wrong on a check, say so explicitly per check — an empty report is a valid outcome but "I didn't get to it" must be distinguished from "I checked and it holds".
